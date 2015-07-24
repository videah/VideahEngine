do
    function interpretCommand(command)
        local arguments = {}
        local argSep = command:find(":", 1, true)

        if argSep ~= nil then
            for argument in string.gmatch(command:sub(argSep + 1), '([^,]+)') do
                arguments[#arguments+1] = argument
            end
            command = command:sub(1, argSep - 1)
        end

        if graphics.printc[command] ~= nil then
            local cmdFunc = graphics.printc[command]
            return 0, cmdFunc(cmd, arguments)
        else
            return 1
        end
    end

    function printf_call(printf, text, x, y, limitx, halign, limity, valign, moreparams)
        moreparams = moreparams or {}
        limitx = limitx or 100000
        halign = halign or "left"
        limity = limity or 100000 --math.huge
        valign = valign or "top"
        local scrollx = (moreparams and moreparams.scrollx) or -1
        local scrolly = (moreparams and moreparams.scrolly) or -1
        local vertScissorBorder = (moreparams and moreparams.vertScissorBorder) or 0

        text = text:gsub("\n", "[n]")

        local currentFont = love.graphics.getFont()
        local strSegment = function(str)
            return {str = str, size = {currentFont:getWidth(str), currentFont:getHeight()}, appendSpace = true}
        end

        -- split into segments
        local cursor = 1
        local errors = 0
        local segments = {}
        while cursor <= text:len() do
            local commandStart = text:find("[", cursor, true)
            local commandEnd = commandStart and text:find("]", commandStart + 1, true)
            local nextSpace = text:find(" ", cursor, true)

            if (commandStart == nil or commandEnd == nil) and nextSpace == nil  then
                segments[#segments+1] = strSegment(text:sub(cursor))
                cursor = text:len() + 1
            else
                local cut = nil
                if commandStart and commandEnd and (nextSpace and commandStart < nextSpace or not nextSpace) then
                    cut = commandStart
                else
                    cut = nextSpace
                end
                local beforeSegment = text:sub(cursor, cut - 1)
                if beforeSegment ~= "" then
                    segments[#segments+1] = strSegment(beforeSegment)
                end

                if cut == commandStart then
                    local err, ret = interpretCommand(text:sub(commandStart + 1, commandEnd - 1))
                    errors = errors + err
                    cursor = commandEnd + 1

                    if err == 0 then
                        ret.size = ret.size or {0, 0}
                        segments[#segments+1] = ret
                    end
                else
                    cursor = nextSpace + 1
                end
            end
        end

        -- split into lines
        local lines = {{width = 0}}
        local curLineIndex = 1
        for i = 1, #segments do
            local curLine = lines[curLineIndex]
            local feed = function()
                curLineIndex = curLineIndex + 1
                lines[curLineIndex] = {width = 0}
                curLine = lines[curLineIndex]
            end

            if segments[i].newline then
                for n = 1, segments[i].newline do feed() end
            end

            -- with scrolling text, don't wrap lines
            if scrollx < 0 and curLine.width + segments[i].size[1] > limitx and curLine.width > 0 then
                feed()
            end

            curLine[#curLine+1] = segments[i]
            curLine.width = curLine.width + segments[i].size[1] + (segments[i].appendSpace == true and currentFont:getWidth(" ") or 0)
        end

        -- drawing
        local scissX, scissY, scissW, scissH = love.graphics.getScissor()
        love.graphics.setScissor(x, y - vertScissorBorder, limitx, limity + vertScissorBorder*2)

        local totalHeight = 0
        for l = 1, #lines do
            local maxHeight = 0
            for s = 1, #lines[l] do
                maxHeight = math.max(maxHeight, lines[l][s].size[2])
            end
            lines[l].height = maxHeight
            totalHeight = totalHeight + maxHeight
        end
        local cy = nil-- cursor
        if valign == "top" then cy = 0 end
        if valign == "center_total" then cy = limity / 2 - totalHeight / 2 end
        if valign == "bottom_total" then cy = limity - totalHeight end
        if valign == "center" then cy = limity / 2 - currentFont:getHeight() / 2 * #lines end
        if valign == "bottom" then cy = limity - currentFont:getHeight() / 2 * #lines end
        assert(cy ~= nil, "vertical align must be top, center or bottom")
        if scrolly >= 0 then cy = cy - scrolly * math.max(0, totalHeight - limity) end

        for l = 1, #lines do
            local cx = nil
            if halign == "left" then cx = 0 end
            if halign == "center" then cx = limitx / 2 - lines[l].width / 2 end
            if halign == "right" then cx = limitx - lines[l].width end
            assert(cx ~= nil, "horizontal align must be left, center or right")
            if scrollx >= 0 then cx = cx - scrollx * math.max(0, lines[l].width - limitx) end

            -- actual drawing
            local minOffY = math.huge
            for s = 1, #lines[l] do
                local segment = lines[l][s]
                local offy = currentFont:getHeight() / 2 - segment.size[2] / 2
                minOffY = math.min(minOffY, offy)

                local px, py = cx + x, cy + y + offy
                if segment.draw then segment.draw(px, py, limity) end
                if segment.str then 
                    if moreparams.border then
                        local r, g, b, a = love.graphics.getColor()
                        love.graphics.setColor(0, 0, 0, 255)
                        love.graphics.print(segment.str, px + 1, py) 
                        love.graphics.print(segment.str, px, py + 1) 
                        love.graphics.print(segment.str, px - 1, py) 
                        love.graphics.print(segment.str, px, py - 1) 
                        love.graphics.setColor(r, g, b, a)
                    end
                    love.graphics.print(segment.str, px, py) 
                end

                cx = cx + segment.size[1] + (segment.appendSpace == true and currentFont:getWidth(" ") or 0)
            end
            cy = cy + minOffY + lines[l].height
        end

        love.graphics.setScissor(scissX, scissY, scissW, scissH)

        return errors
	end

    local printf = setmetatable({}, {__call = printf_call})

    printf["blank"] = function(cmd, arguments)
        return {size = {tonumber(arguments[1]), tonumber(arguments[2] or 0)}}
    end

    printf["["] = function(cmd, arguments)
    local font = love.graphics.getFont()
        return {str = "[", size = {font:getWidth("["), font:getHeight()}}
    end

    printf["color"] = function(cmd, arguments)
        return {draw = function() love.graphics.setColor(unpack(arguments)) end}
    end

    printf["n"] = function(cmd, arguments)
        return {newline = 1}
    end

    function img_call(printfImg, cmd, arguments)
        local img = printfImg[arguments[1]]
        local scale = arguments[2] or 1.0
        return {size = {img:getWidth() * scale, img:getHeight() * scale}, draw = function(x, y) love.graphics.draw(img, x, y, 0.0, scale, scale) end, appendSpace = true}
    end
    printf["img"] = setmetatable({}, {__call = img_call})

    return printf
end
