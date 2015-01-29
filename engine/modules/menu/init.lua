menu = {}
menu.bg = {}

local path = ... .. "."

menu.config = require(path .. 'config') -- Load menu config.

function menu.draw()

	menu.bg.draw()

end

function menu.update(dt)

end

function menu.bg.draw()

	if menu.config.type == "tiled" then

		menu.config.image:setWrap('repeat', 'repeat')
		menu.bgQuad = love.graphics.newQuad( 0, 0, global.screenWidth, global.screenHeight, menu.image:getHeight(), menu.image:getWidth() )
		love.graphics.draw( menu.config.image, menu.bgQuad, 0, 0)

	elseif menu.config.type == "fill" then

		love.graphics.setColor(menu.config.bgcolor)
		love.graphics.rectangle( "fill", 0, 0, global.screenWidth, global.screenHeight )
		love.graphics.setColor(255, 255, 255, 255)

	elseif menu.config.type == "scrolling_tiled" then

		menu.config.image:setWrap('repeat', 'repeat')
		menu.bgQuad = love.graphics.newQuad( menu.bgOffset, 0, global.screenWidth, global.screenHeight, menu.image:getHeight(), menu.image:getWidth() )
		love.graphics.draw( menu.image, menu.bgQuad, 0, 0)

	end

end

return menu