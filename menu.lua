menu = {}

function menu.load()

	menu.title = "Untitled Game"
	menu.titleimage = "data/images/videahenginelogo.png"
	menu.titletype = "image"

	menu.image = "data/images/menubg.png"
	menu.options = {"Start", "Options", "Customize", "Quit"}
	menu.optionsstate = {"game", "options", "customize", "quit"}

	menu.type = "scrolling_tiled"
	menu.scrolldirection = "left"
	menu.scrollspeed = 50

	menu.InternalVariables()

	menu.GenerateMenuFrame()

	print("Loaded menu system ...")

end

function menu.draw()

	menu.GenerateBackground()
	menu.Generatetitle()

end

function menu.update(dt)

	menu.CalculateScrolling(dt)

end

function menu.GenerateBackground()

	if menu.type == "tiled" then

		menu.image:setWrap('repeat', 'repeat')
		menu.bgQuad = love.graphics.newQuad( 0, 0, global.screenWidth, global.screenHeight, menu.image:getHeight(), menu.image:getWidth() )
		love.graphics.draw( menu.image, menu.bgQuad, 0, 0)

	elseif menu.type == "fill" then

		--TODO: Add code for more types of menu backgrounds.

	elseif menu.type == "scrolling_tiled" then

		menu.image:setWrap('repeat', 'repeat')
		menu.bgQuad = love.graphics.newQuad( menu.bgOffset, 0, global.screenWidth, global.screenHeight, menu.image:getHeight(), menu.image:getWidth() )
		love.graphics.draw( menu.image, menu.bgQuad, 0, 0)

	elseif menu.type == "color" then

		love.graphics.setColor(menu.config.bgcolor)
		love.graphics.rectangle( "fill", 0, 0, global.screenWidth, global.screenHeight )
		love.graphics.setColor(255, 255, 255, 255)

	end
end

function menu.Generatetitle()

	if menu.titletype == "text" then
		love.graphics.setFont(font.menutitle)

		love.graphics.printf(menu.title, 0, global.screenHeight / 10, global.screenWidth, 'center')

		love.graphics.setFont(font.default)
	end

	if menu.titletype == "image" then

		love.graphics.draw(menu.titleimage, (global.screenWidth / 2) - (menu.titleimage:getWidth() / 2), 0)

	end

end

function menu.GenerateMenuFrame()

	button = {}
	buttonStartPos = 30

	local menuframe = loveframes.Create("frame")
	menuframe:SetName("")
	menuframe:SetDraggable(false)
	menuframe:ShowCloseButton(false)
	menuframe:SetWidth(300)
	menuframe:SetHeight(30 + #menu.options * 55)
	menuframe:Center()
	menuframe:SetState("menu")

	for i=1, #menu.options, 1 do

		button[i] = loveframes.Create("button", menuframe)
		button[i]:SetText(menu.options[i])
		button[i]:SetWidth(290)
		button[i]:SetHeight(50)
		button[i]:SetPos(5, buttonStartPos)
		buttonStartPos = buttonStartPos + 55
		button[i].OnClick = function(object, x, y)

			state:changeState(menu.optionsstate[i])

		end

	end

end

function menu.CalculateScrolling(dt)

	if menu.type == "scrolling_tiled" then
		if menu.scrolldirection == "left" then

			menu.bgOffset = menu.bgOffset + menu.scrollspeed * dt

		elseif menu.scrolldirection == "right" then

			menu.bgOffset = menu.bgOffset - menu.scrollspeed * dt

		end
	end
end



function menu.InternalVariables()

	menu.image = love.graphics.newImage( menu.image )
	menu.titleimage = love.graphics.newImage( menu.titleimage )
	menu.bgOffset = 0

end