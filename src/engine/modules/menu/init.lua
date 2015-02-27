-- Dependencies: input, graphics --

local path = ... .. "."

local menu = {}
menu.bg = {}
menu.sidepanel = {}
menu.button = {}
menu.buttonlist = {}

menu.bg.tileoffset = 0

menu.title = {}

menu.config = require(path .. 'config') -- Load menu config.
menu.config.bg.image = engine.graphics.newImage(game.path .. menu.config.bg.image)

if menu.config.title.type == "image" then
	menu.config.title.image = engine.graphics.newImage(game.path .. menu.config.title.image)
end

-- Dependencies --

assert(engine.input, "The 'menu' module requires the 'input' module to be loaded.")
assert(engine.graphics, "The 'menu' module requires the 'graphics' module to be loaded.")

------------------

engine.input.mouse.bind("l", "menu.leftclick")

function menu.draw()

	menu.bg.draw()
	menu.title.draw()
	menu.sidepanel.draw()

end

function menu.update(dt)

	menu.bg.update(dt)
	menu.sidepanel.update(dt)

end

function menu.addButton(text, x, y, func, image)

	local tbl = {text = text, x = x, y = y, func = func or nil, image = image or nil, hover = false}
	table.insert(menu.buttonlist, tbl)

end

-- Default Side Panel --
function menu.sidepanel.draw()

	local color = menu.config.sidepanel.color
	local width = menu.config.sidepanel.width

	love.graphics.setColor(color)
	love.graphics.rectangle( "fill", 0, 0, width, _G.screenHeight )
	love.graphics.setColor(255, 255, 255, 255)

	for i=1, #menu.buttonlist do

		menu.button.draw(i)

	end

end

function menu.sidepanel.update(dt)

	menu.button.update(dt)

end

function menu.button.draw(i)

	local width = menu.config.sidepanel.width

	local height = menu.config.button.height

	local buttonpos = ((i - 1) * (height + menu.config.button.gap)) -- Creates a list of buttons, rather than them all overlapping.

	buttonpos = buttonpos + ((_G.screenHeight / 2)) -- Centers the starting position to screenWidth.

	buttonpos = buttonpos - (height * #menu.buttonlist / 2) -- Centers the list to the middle button.

	menu.buttonlist[i].y = buttonpos

	local font = menu.config.button.font

	love.graphics.setColor(25, 25, 25, 200)
	love.graphics.rectangle("fill", 0, menu.buttonlist[i].y, width, height)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.setFont(menu.config.button.font)

	love.graphics.print(menu.buttonlist[i].text, (width / 2) - (font:getWidth(menu.buttonlist[i].text) / 2), (menu.buttonlist[i].y + (height / 2)) - (font:getHeight() / 2))

end

function menu.button.update(dt)

	local width = menu.config.sidepanel.width
	local height = menu.config.button.height

	for i=1, #menu.buttonlist do

		local x = menu.buttonlist[i].x
		local y = menu.buttonlist[i].y

		if _G.cursorx >= x and _G.cursorx <= (x + width) and _G.cursory >= y and _G.cursory <= (y + height) then
			menu.buttonlist[i].hover = true
		else
			menu.buttonlist[i].hover = false
		end

	end

	for i=1, #menu.buttonlist do

		local hover = menu.buttonlist[i].hover
			
		if hover then

			if engine.input.mouse.isDown("menu.leftclick") then

				menu.buttonlist[i].func()

			end

		end

	end

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
		love.graphics.rectangle( "fill", 0, 0, _G.screenWidth, _G.screenHeight )
		love.graphics.setColor(255, 255, 255, 255)

	elseif menu.config.type == "scrolling_tiled" then

		image:setWrap('repeat', 'repeat')
		menu.bgQuad = love.graphics.newQuad( offset, 0, _G.screenWidth, _G.screenHeight, image:getHeight(), image:getWidth() )
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

function menu.title.draw()

	local image = menu.config.title.image
	local text = menu.config.title.text
	local typ = menu.config.title.type
	local scale = menu.config.title.imagescale

	if typ == "image" then

		local x = _G.screenWidth / 2
		x = x - ((image:getWidth() * scale) / 2)
		x = x + (menu.config.sidepanel.width / 2)

		local y = _G.screenHeight / 2
		y = y - ((image:getHeight() * scale) / 2)

		love.graphics.draw(image, x, y, 0, scale, scale)

	end

end

return menu