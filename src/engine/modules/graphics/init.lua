local graphics = {}
local path = ... .. '.'

graphics.printc = require(path .. 'superprintf')

-- Print Content properties --

	-- Colors --

	graphics.printc['white'] = function() return graphics.printc.color("", {255, 255, 255, 255}) end -- Red
	graphics.printc['red'] = function() return graphics.printc.color("", {255, 0, 0, 255}) end -- Red
	graphics.printc['green'] = function() return graphics.printc.color("", {0, 255, 0, 255}) end -- Green
	graphics.printc['blue'] = function() return graphics.printc.color("", {0, 0, 255, 255}) end -- Blue
	graphics.printc['rainbow'] = function() return graphics.printc.color("", {math.random(0, 255), math.random(0, 255), math.random(0, 255), 255}) end -- Rainbow

------------------------------

function graphics.newImage(filename)

	local image = nil

	if love.filesystem.exists(filename) then

		image = love.graphics.newImage(filename)

	else

		local missingtexture = 'engine/data/images/missing.png'

		assert(love.filesystem.exists(missingtexture), "CRITICAL ERROR: cannot load missing texture")

		image = love.graphics.newImage(missingtexture)

	end

	return image

end

function graphics.rectangle(mode, x, y, width, height, bordersize)

	assert(mode == "fill" or mode == "line", "mode requires a valid value.")

	bordersize = bordersize or 0

	if mode == "fill" then
		love.graphics.rectangle(mode, x, y, width, height)
	end

	if mode == "line" and bordersize <= 0 then
		bordersize = 1
	end

	-- Border --

	if bordersize ~= 0 then

		-- Top Bar --
		love.graphics.rectangle("fill", x - bordersize, y - bordersize, width + bordersize * 2, bordersize)

		-- Left Bar --

		love.graphics.rectangle("fill", x - bordersize, y - bordersize, bordersize, height + bordersize * 2)

		-- Right Bar --

		love.graphics.rectangle("fill", x + width, y - bordersize, bordersize, height + bordersize * 2)

		-- Bot Bar --

		love.graphics.rectangle("fill", x - bordersize, y + height, width + bordersize * 2, bordersize)

	end

end

function graphics.missingTex()

	return love.graphics.newImage('engine/data/images/missing.png')

end

return graphics