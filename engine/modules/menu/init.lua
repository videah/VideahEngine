menu = {}
menu.bg = {}

local path = ... .. "."

menu.config = require(path .. 'config') -- Load menu config.
menu.config.bgimage = love.graphics.newImage(game.path .. menu.config.bgimage)

menu.bg.tileoffset = 0

function menu.draw()

	menu.bg.draw()

end

function menu.update(dt)

	menu.bg.update(dt)

end

function menu.bg.draw()

	local image = menu.config.bgimage
	local color = menu.config.bgcolor
	local offset = menu.bg.tileoffset

	if menu.config.type == "tiled" then

		image:setWrap('repeat', 'repeat')
		menu.bgQuad = love.graphics.newQuad( 0, 0, global.screenWidth, global.screenHeight, menu.image:getHeight(), menu.image:getWidth() )
		love.graphics.draw( image, menu.bgQuad, 0, 0)

	elseif menu.config.type == "fill" then

		love.graphics.setColor(color)
		love.graphics.rectangle( "fill", 0, 0, engine.global.screenWidth, engine.global.screenHeight )
		love.graphics.setColor(255, 255, 255, 255)

	elseif menu.config.type == "scrolling_tiled" then

		image:setWrap('repeat', 'repeat')
		menu.bgQuad = love.graphics.newQuad( offset, 0, engine.global.screenWidth, engine.global.screenHeight, image:getHeight(), image:getWidth() )
		love.graphics.draw( image, menu.bgQuad, 0, 0)

	end

end

function menu.bg.update(dt)

	if menu.config.type == "scrolling_tiled" then
		if menu.config.scrolldirection == "left" then

			menu.bg.tileoffset = menu.bg.tileoffset + menu.config.scrollspeed * dt

		elseif menu.scrolldirection == "right" then

			menu.bg.tileoffset = menu.bg.tileoffset - menu.config.scrollspeed * dt

		end
	end

end

return menu