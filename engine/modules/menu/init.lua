menu = {}
menu.bg = {}
menu.sidepanel = {}
menu.buttonlist = {}

local path = ... .. "."

menu.config = require(path .. 'config') -- Load menu config.
menu.config.bg.image = love.graphics.newImage(game.path .. menu.config.bg.image)

menu.bg.tileoffset = 0

function menu.draw()

	menu.bg.draw()
	menu.sidepanel.draw()

end

function menu.update(dt)

	menu.bg.update(dt)

end

function menu.addButton(text, func, image)

	local tbl = {text = text, func = func, image = image}
	table.insert(menu.buttonlist, tbl)

end

-- Default Side Panel --
function menu.sidepanel.draw()

	local color = menu.config.sidepanel.color
	local width = menu.config.sidepanel.width

	love.graphics.setColor(color)
	love.graphics.rectangle( "fill", 0, 0, width, engine.global.screenHeight )
	love.graphics.setColor(255, 255, 255, 255)

	for i=1, #menu.buttonlist do

		local height = menu.config.button.height

		local buttonpos = (i - 1) * height -- Creates a list of buttons, rather than them all overlapping.

		buttonpos = buttonpos + ((engine.global.screenHeight / 2)) -- Centers the starting position to screenWidth.

		buttonpos = buttonpos - (height * #menu.buttonlist / 2) -- Centers the list to the middle button.

		love.graphics.setColor(25, 25, 25, 200)
		love.graphics.rectangle("fill", 0, buttonpos, width, height)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(menu.buttonlist[i].text .. i, 0, buttonpos)

	end

end

function menu.sidepanel.update(dt)

end

-- Default Background --

function menu.bg.draw()

	local image = menu.config.bg.image
	local color = menu.config.bg.color
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