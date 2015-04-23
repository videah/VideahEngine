local ui_path = tostring(...):sub(1, -9)
local Object = require(ui_path .. 'classic/classic')
local Base = require(ui_path .. 'Base')
local Textarea = Object:extend('Textarea')
Textarea:implement(Base)

function Textarea:new(ui, x, y, w, h, settings)
    self.ui = ui
    self.id = self.ui.addToElementsList(self)
    self.type = 'Textarea'

    self:basePreNew(x, y, w, h, settings)
    self:bind('mouse1', 'left-click')
    self:bind('left', 'move-left')
    self:bind('right', 'move-right')
    self:bind('up', 'move-up')
    self:bind('down', 'move-down')
    self:bind('lshift', 'lshift')
    self:bind('backspace', 'backspace')
    self:bind('delete', 'delete')
    self:bind('lctrl', 'lctrl')
    self:bind('home', 'first')
    self:bind('end', 'last')
    self:bind('x', 'cut')
    self:bind('c', 'copy')
    self:bind('v', 'paste')
    self:bind('a', 'all')

    self.single_line = settings.single_line
    self.text_margin = settings.text_margin or 5
    self.wrap_width = settings.wrap_width or (self.w - 4*self.text_margin)
    self.text_add_x = 0
    self.text_x, self.text_y = self.x + self.text_margin, self.y + self.text_margin
    self.text_ix, self.text_iy = self.text_x, self.text_y
    self.text_base_x, self.text_base_y = self.text_x, self.text_y
    self.editing_locked = settings.editing_locked

    self.font = settings.font or love.graphics.getFont()
    self.text_table = {}
    self.copy_buffer = {}
    self.index = 1
    self.selection_index = nil
    self.selection_positions = {}
    self.selection_sizes = {}
    self.key_pressed_time = 0
    self.mouse_all_selected = false
    self.mouse_pressed_time = false
    self.last_mouse_pressed_time = false

    if self.single_line then self.text_settings = {font = self.font}
    else self.text_settings = {font = self.font, wrap_width = self.wrap_width} end
    self.text = self.ui.Text(self.text_x, self.text_y, self:join(), self.text_settings) 
    if self.single_line then self.h = self.text.font:getHeight() + 4*self.text_margin end

    self:basePostNew()
end

function Textarea:update(dt, parent)
    self:basePreUpdate(dt, parent)
    if parent then self.text_base_x, self.text_base_y = parent.x + self.text_ix, parent.y + self.text_iy end
    self.text_x, self.text_y = self.text_base_x + (self.text_margin or 0) + self.text_add_x, self.text_base_y + (self.text_margin or 0)
    self.text.x, self.text.y = self.text_x, self.text_y
    self.text:update(dt)

    if self.editing_locked then 
        self.selected = false
        return
    end

    -- Figure out selection/cursor position in pixels
    self.selection_positions = {}
    self.selection_sizes = {}
    local line_string = self:getLineString(self:getIndexLine(self.index) or self:getIndexLine(self.index - 1))
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.index)) or self:getIndexOfFirstInLine(self:getIndexLine(self.index - 1)) or 1
    local line_last_index = self:getIndexOfLastInLine(self:getIndexLine(self.index)) or (line_first_index + #line_string - 1)
    -- No selection, just cursor
    if not self.selection_index then
        local u = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index))
        local v = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index + 1))
        if self.index == #self.text_table + 1 then v = v + self.text.font:getWidth('a') end
        local h = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1) or 0
        table.insert(self.selection_positions, {x = self.text_x + u, y = self.text_y + h*self.font:getHeight()})
        table.insert(self.selection_sizes, {w = v - u, h = self.font:getHeight()})
    -- Selection
    else
        local index_line = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1)
        local selection_index_line = self:getIndexLine(self.selection_index - 1) or self:getIndexLine(self.selection_index)
        -- Multi line selection
        if index_line ~= selection_index_line then
            -- Forward
            if self.index <= self.selection_index then
                local n_mid_lines = selection_index_line - index_line - 1
                -- Fill starting line
                local u = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index))
                local v = self.text.font:getWidth(line_string:utf8sub(1, line_last_index - line_first_index + 1))
                local h = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1) or 0
                table.insert(self.selection_positions, {x = self.text_x + u, y = self.text_y + h*self.font:getHeight()})
                table.insert(self.selection_sizes, {w = v - u, h = self.font:getHeight()})
                -- Fill mid lines
                for i = 1, n_mid_lines do
                    local first_index_in_mid_line = self:getIndexOfFirstInLine(index_line + i)
                    local mid_line_string = self:getLineString(self:getIndexLine(first_index_in_mid_line))
                    table.insert(self.selection_positions, {x = self.text_x, y = self.text_y + (h+i)*self.font:getHeight()})
                    table.insert(self.selection_sizes, {w = self.text.font:getWidth(mid_line_string), h = self.font:getHeight()})
                end
                -- Fill end line
                local next_line_string = self:getLineString(self:getIndexLine(self.selection_index - 1) or self:getIndexLine(self.selection_index))
                local next_line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index - 1)) or self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index)) or 1
                local z = self.text.font:getWidth(next_line_string:utf8sub(1, self.selection_index - next_line_first_index))
                local h2 = self:getIndexLine(self.selection_index - 1) or self:getIndexLine(self.selection_index) or 0
                table.insert(self.selection_positions, {x = self.text_x, y = self.text_y + h2*self.font:getHeight()})
                table.insert(self.selection_sizes, {w = z, h = self.font:getHeight()})
            -- Backwards
            else
                local n_mid_lines = index_line - selection_index_line - 1
                -- Fill starting line
                local z = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index))
                local h = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1) or 0
                table.insert(self.selection_positions, {x = self.text_x, y = self.text_y + h*self.font:getHeight()})
                table.insert(self.selection_sizes, {w = z, h = self.font:getHeight()})
                -- Fill mid lines
                for i = 1, n_mid_lines do
                    local first_index_in_mid_line = self:getIndexOfFirstInLine(index_line - i)
                    local mid_line_string = self:getLineString(self:getIndexLine(first_index_in_mid_line))
                    table.insert(self.selection_positions, {x = self.text_x, y = self.text_y + (h-i)*self.font:getHeight()})
                    table.insert(self.selection_sizes, {w = self.text.font:getWidth(mid_line_string), h = self.font:getHeight()})
                end
                -- Fill end line
                local previous_line_string = self:getLineString(self:getIndexLine(self.selection_index - 1) or self:getIndexLine(self.selection_index) or 0)
                local previous_line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index - 1)) or self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index)) or 1
                local previous_line_last_index = self:getIndexOfLastInLine(self:getIndexLine(self.selection_index - 1)) or self:getIndexOfLastInLine(self:getIndexLine(self.selection_index)) or 1
                local u = self.text.font:getWidth(previous_line_string:utf8sub(1, self.selection_index - previous_line_first_index))
                local v = self.text.font:getWidth(previous_line_string:utf8sub(1, previous_line_last_index - previous_line_first_index + 1))
                local h2 = self:getIndexLine(self.selection_index) or self:getIndexLine(self.selection_index - 1) or 0
                table.insert(self.selection_positions, {x = self.text_x + u, y = self.text_y + h2*self.font:getHeight()})
                table.insert(self.selection_sizes, {w = v - u, h = self.font:getHeight()})

            end
        -- Single line selection
        else
            local u = self.text.font:getWidth(line_string:utf8sub(1, self.index - line_first_index))
            local v = self.text.font:getWidth(line_string:utf8sub(1, self.selection_index - line_first_index))
            local h = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1) or 0
            table.insert(self.selection_positions, {x = self.text_x + u, y = self.text_y + h*self.font:getHeight()})
            table.insert(self.selection_sizes, {w = v - u, h = self.font:getHeight()})
        end
    end

    -- Single line text scrolling
    local w = self.w - 2*self.text_margin
    if self.single_line and #self.selection_positions > 0 then
        if not self.selection_index then
            local x1, y1 = self.selection_positions[1].x - self.text_x, self.selection_positions[1].y
            local x2, y2 = x1 + self.selection_sizes[1].w, y1 + self.selection_sizes[1].h
            if x2 > w - self.text_add_x then
                self.text_add_x = self.text_add_x - w/2
            elseif x1 < -self.text_add_x then
                self.text_add_x = self.text_add_x + w/2
            end
        else
            local x1, y1 = self.selection_positions[1].x - self.text_x, self.selection_positions[1].y
            local n = #self.selection_positions
            local x2, y2 = self.selection_positions[n].x - self.text_x + self.selection_sizes[n].w, self.selection_positions[n].y + self.selection_sizes[n].h
            if x2 > w - self.text_add_x then
                self.text_add_x = self.text_add_x - w/2
            elseif x2 < -self.text_add_x then
                self.text_add_x = self.text_add_x + w/2
            end
        end
    end

    -- Everything up has to happen every frame if the textarea is selected or not
    if not self.selected then return end
    -- Everything down has to happen only if the textarea is selected
    
    -- Cursor selection with mouse
    local mx, my = love.mouse.getPosition()
    if self.hot and self.input:pressed('left-click') then
        self.selection_index = false
        self.mouse_all_selected = false
        self.mouse_pressing = true
        for i, c in ipairs(self.text.characters) do
            local line_string = self:getLineString(c.line)
            local line_first_index = self:getIndexOfFirstInLine(c.line)
            local x, y = self.text_x + self.text.font:getWidth(line_string:utf8sub(1, i - line_first_index)), self.text_y + c.line*self.text.font:getHeight()
            local w, h = self.text.font:getWidth(c.character), self.text.font:getHeight()
            if mx >= x and mx <= x + w and my >= y and my <= y + h then self.index = i; break end
        end
    end
    if not self.mouse_all_selected and self.mouse_pressing and self.input:down('left-click') then
        for i, c in ipairs(self.text.characters) do
            local line_string = self:getLineString(c.line)
            local line_first_index = self:getIndexOfFirstInLine(c.line)
            local x, y = self.text_x + self.text.font:getWidth(line_string:utf8sub(1, i - line_first_index)), self.text_y + c.line*self.text.font:getHeight()
            local w, h = self.text.font:getWidth(c.character), self.text.font:getHeight()
            if mx >= x and mx <= x + w and my >= y and my <= y + h then self.selection_index = i + 1; break end
            if self.index == self.selection_index then self.selection_index = nil end
        end
    end
    if self.mouse_pressing and self.input:released('left-click') then
        self.mouse_pressing = false
    end

    -- Cursor double click all selection
    if self.hot and self.input:pressed('left-click') then
        self.mouse_pressed_time = love.timer.getTime()
        if self.last_mouse_pressed_time then
            if self.mouse_pressed_time - self.last_mouse_pressed_time < 0.3 then self.mouse_all_selected = true end
        end
    end
    if self.mouse_all_selected then self:selectAll() end

    -- Move cursor left
    if not self.input:down('lshift') and self.input:pressed('move-left') then
        self.key_pressed_time = love.timer.getTime()
        self:moveLeft()
    end
    if not self.input:down('lshift') and self.input:down('move-left') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:moveLeft() end
    end

    -- Move cursor right
    if not self.input:down('lshift') and self.input:pressed('move-right') then
        self.key_pressed_time = love.timer.getTime()
        self:moveRight()
    end
    if not self.input:down('lshift') and self.input:down('move-right') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:moveRight() end
    end

    -- Move cursor up
    if not self.input:down('lshift') and self.input:pressed('move-up') then
        self.key_pressed_time = love.timer.getTime()
        self:moveUp()
    end
    if not self.input:down('lshift') and self.input:down('move-up') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:moveUp() end
    end

    -- Move cursor down
    if not self.input:down('lshift') and self.input:pressed('move-down') then
        self.key_pressed_time = love.timer.getTime()
        self:moveDown()
    end
    if not self.input:down('lshift') and self.input:down('move-down') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:moveDown() end
    end

    -- Move cursor to beginning
    if self.input:pressed('first') then self:first() end

    -- Move cursor to end
    if self.input:pressed('last') then self:last() end

    -- Select left
    if self.input:down('lshift') and self.input:pressed('move-left') then
        self.key_pressed_time = love.timer.getTime()
        self:selectLeft()
    end
    if self.input:down('lshift') and self.input:down('move-left') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:selectLeft() end
    end

    -- Select right
    if self.input:down('lshift') and self.input:pressed('move-right') then
        self.key_pressed_time = love.timer.getTime()
        self:selectRight()
    end
    if self.input:down('lshift') and self.input:down('move-right') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:selectRight() end
    end

    -- Select up
    if self.input:down('lshift') and self.input:pressed('move-up') then
        self.key_pressed_time = love.timer.getTime()
        self:selectUp()
    end
    if self.input:down('lshift') and self.input:down('move-up') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:selectUp() end
    end

    -- Select down
    if self.input:down('lshift') and self.input:pressed('move-down') then
        self.key_pressed_time = love.timer.getTime()
        self:selectDown()
    end
    if self.input:down('lshift') and self.input:down('move-down') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:selectDown() end
    end

    -- Select all
    if self.input:down('lctrl') and self.input:pressed('all') then self:selectAll() end

    -- Delete before cursor
    if self.input:pressed('backspace') then
        self.key_pressed_time = love.timer.getTime()
        self:backspace()
    end
    if self.input:down('backspace') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:backspace() end
    end

    -- Delete after cursor
    if self.input:pressed('delete') then
        self.key_pressed_time = love.timer.getTime()
        self:delete()
    end
    if self.input:down('delete') then
        if love.timer.getTime() - self.key_pressed_time > 0.2 then self:delete() end
    end

    if self.input:pressed('cut') then self:cut() end
    if self.input:pressed('copy') then self:copy() end
    if self.input:pressed('paste') then self:paste() end

    self:basePostUpdate(dt)

    self.last_mouse_pressed_time = self.mouse_pressed_time
end

function Textarea:draw()
    love.graphics.setStencil(function() love.graphics.rectangle('fill', self.x, self.y, self.w, self.h) end)
    self:baseDraw()
    love.graphics.setStencil()
end

function Textarea:updateText()
    self.text = self.ui.Text(self.text_x, self.text_y, self:join(), self.text_settings)
end

function Textarea:textinput(text, dont_update)
    if not self.selected then return end
    self:deleteSelected()
    table.insert(self.text_table, self.index, text)
    self.index = self.index + 1
    if not dont_update then self:updateText() end
end

function Textarea:addText(text)
    local previous_selected = self.selected
    self.selected = true
    for i = 1, #text do
        self:textinput(text:utf8sub(i, i), true)
    end
    self.selected = previous_selected
    self:updateText()
end

function Textarea:join(table)
    local table = table or self.text_table
    local string = ''
    for i, c in ipairs(table) do string = string .. c end
    return string
end

function Textarea:getLineString(line)
    local string = ''
    for i, c in ipairs(self.text.characters) do
        if c.line == line then string = string .. c.character end
    end
    return string
end

function Textarea:getIndexLine(index)
    for i, c in ipairs(self.text.characters) do
        if i == index then return c.line end
    end
end

function Textarea:getIndexOfFirstInLine(line)
    for i, c in ipairs(self.text.characters) do
        if c.line == line then return i end
    end
end

function Textarea:getIndexOfLastInLine(line)
    for i, c in ipairs(self.text.characters) do
        if c.line ~= line and self.text.characters[i-1] and self.text.characters[i-1].line == line then return i-1 end
    end
end

function Textarea:getMaxLines()
    local n_lines = 0
    for i, c in ipairs(self.text.characters) do n_lines = c.line + 1 end
    return n_lines
end

function Textarea:moveLeft()
    self.mouse_all_selected = false
    if self.selection_index then self.index = self.selection_index end
    self.index = self.index - 1
    self.selection_index = nil
    if self.index < 1 then self.index = 1 end
end

function Textarea:moveRight()
    self.mouse_all_selected = false
    if self.selection_index then self.index = self.selection_index - 1 end
    self.index = self.index + 1
    self.selection_index = nil
    if self.index > #self.text_table + 1 then self.index = #self.text_table + 1 end
end

function Textarea:moveUp()
    self.mouse_all_selected = false
    if self.selection_index then self.index = self.selection_index end
    local index_line = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1)
    if index_line == 0 then 
        self.index = 1
        self.selection_index = nil
        return 
    end
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.index)) or 1
    local w = self.text.font:getWidth(self:getLineString(index_line):utf8sub(1, self.index - line_first_index))
    local string = ''
    for i, c in ipairs(self.text.characters) do
        if c.line == index_line - 1 then
            string = string .. c.character
            local lw = self.text.font:getWidth(string)
            if lw >= w then 
                if w == 0 then self.index = i
                else self.index = i + 1 end
                self.selection_index = nil
                return 
            end
        end
    end
end

function Textarea:moveDown()
    self.mouse_all_selected = false
    if self.selection_index then self.index = self.selection_index end
    local index_line = self:getIndexLine(self.index) or self:getIndexLine(self.index - 1)
    if index_line == self:getMaxLines() - 1 then 
        self.index = #self.text.characters
        self.selection_index = nil
        return 
    end
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.index)) or 1
    local w = self.text.font:getWidth(self:getLineString(index_line):utf8sub(1, self.index - line_first_index))
    local string = ''
    for i, c in ipairs(self.text.characters) do
        if c.line == index_line + 1 then
            string = string .. c.character
            local lw = self.text.font:getWidth(string)
            if lw >= w then 
                if w == 0 then self.index = i
                else self.index = i + 1 end
                self.selection_index = nil
                return 
            end
        end
    end
    self.index = #self.text.characters
    self.selection_index = nil
end

function Textarea:selectLeft()
    self.mouse_all_selected = false
    if not self.selection_index then self.selection_index = self.index - 1
    else self.selection_index = self.selection_index - 1 end
    if self.selection_index < 1 then self.selection_index = 1 end
end

function Textarea:selectRight()
    self.mouse_all_selected = false
    if not self.selection_index then self.selection_index = self.index + 1
    else self.selection_index = self.selection_index + 1 end
    if self.selection_index > #self.text_table + 1 then self.selection_index = #self.text_table + 1 end
end

function Textarea:selectUp()
    self.mouse_all_selected = false
    if not self.selection_index then self.selection_index = self.index end
    local index_line = self:getIndexLine(self.selection_index) or self:getIndexLine(self.selection_index - 1)
    if index_line == 0 then 
        self.selection_index = 1
        return 
    end
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index)) or 1
    local w = self.text.font:getWidth(self:getLineString(index_line):utf8sub(1, self.selection_index - line_first_index))
    local string = ''
    for i, c in ipairs(self.text.characters) do
        if c.line == index_line - 1 then
            string = string .. c.character
            local lw = self.text.font:getWidth(string)
            if lw >= w then 
                if w == 0 then self.selection_index = i
                else self.selection_index = i + 1 end
                return 
            end
        end
    end
end

function Textarea:selectDown()
    self.mouse_all_selected = false
    if not self.selection_index then self.selection_index = self.index + 1 end
    local index_line = self:getIndexLine(self.selection_index) or self:getIndexLine(self.selection_index - 1)
    if index_line == self:getMaxLines() - 1 then 
        self.selection_index = #self.text.characters + 1
        return 
    end
    local line_first_index = self:getIndexOfFirstInLine(self:getIndexLine(self.selection_index)) or 1
    local w = self.text.font:getWidth(self:getLineString(index_line):utf8sub(1, self.selection_index - line_first_index))
    local string = ''
    for i, c in ipairs(self.text.characters) do
        if c.line == index_line + 1 then
            string = string .. c.character
            local lw = self.text.font:getWidth(string)
            if lw >= w then 
                if w == 0 then self.selection_index = i
                else self.selection_index = i + 1 end
                return 
            end
        end
    end
    self.selection_index = #self.text.characters + 1
end

function Textarea:selectAll()
    self.index = 1
    self.selection_index = #self.text.characters + 1
end

function Textarea:first()
    self.index = 1
    self.selection_index = nil
    self.mouse_all_selected = false
end

function Textarea:last()
    self.index = #self.text.characters + 1
    self.selection_index = nil
    self.mouse_all_selected = false
end

function Textarea:deleteSelected()
    if not self.selection_index then return end
    if self.index == self.selection_index then return end
    local min, max = 0, 0
    if self.index < self.selection_index then min = self.index; max = self.selection_index - 1
    elseif self.selection_index < self.index then min = self.selection_index; max = self.index - 1 end
    for i = max, min, -1 do table.remove(self.text_table, i) end
    self.index = min
    self.selection_index = nil
    self.mouse_all_selected = false
end

function Textarea:backspace()
    if self.selection_index then self:deleteSelected()
    else 
        if self.index > 1 then
            table.remove(self.text_table, self.index - 1) 
            self.index = self.index - 1
        end
    end
    self:updateText()
end

function Textarea:delete()
    if self.selection_index then self:deleteSelected()
    else
        table.remove(self.text_table, self.index) 
        if self.index == #self.text.characters then 
            self.index = self.index - 1 
            if self.index < 1 then self.index = 1 end
        end
    end
    self:updateText()
end

function Textarea:copy()
    if not self.selection_index then return end
    if self.index == self.selection_index then return end
    self.copy_buffer = {}
    local min, max = 0, 0
    if self.index < self.selection_index then min = self.index; max = self.selection_index - 1
    elseif self.selection_index < self.index then min = self.selection_index; max = self.index - 1 end
    for i = min, max do table.insert(self.copy_buffer, self.text.characters[i].character) end
end

function Textarea:cut()
    self:copy()
    self:deleteSelected()
    self:updateText()
end

function Textarea:paste()
    self:deleteSelected()
    local copy = love.system.getClipboardText()

    for i = 1, string.len(copy) do
        table.insert(self.text_table, self.index, string.sub(copy, i, i))
        self.index = self.index + 1
    end

    self:updateText()
end

return Textarea
