game = {}
game.path = ... .. '/'

game.playername = "Untitled Player"

function game.load()

	-- Set default state --
	engine.state.setState("splash")

	-- Splash Screen --
	engine.splash.addSplash(love.graphics.newImage("game/data/images/splashes/love.png"))
	engine.splash.onComplete(function() engine.state.setState("menu") end)

	-- Debug Vars --
	engine.panel.addVar("FPS", function() return _G.fps end)
	--engine.input.mouse.bind("l", "click")

	-- Menu Buttons --
	engine.menu.addButton("Start", 0, 0, function() engine.state.setState("game") end)
	engine.menu.addButton("Quit", 0, 0, function() love.event.quit() end)

end

function game.draw()

	if engine.state:isCurrentState("menu") then	
		engine.menu.draw()
	end

	if engine.state:isCurrentState("game") then

		engine.camera:set()

		engine.map.lightworld:draw(function()

			engine.map.draw()

		end)

			-- Game Draw Code Here --

		engine.camera:unset()

		engine.chat.draw()

	end

end

function game.update(dt)

	if engine.state:isCurrentState("menu") then
		engine.menu.update(dt)
	end

	if engine.state:isCurrentState("game") then
		engine.camera.update(dt)

		engine.map.lightworld:update(dt)
		engine.map.lightworld:setTranslation(engine.camera:getX(), engine.camera:getY(), engine.camera:getScale())

		if love.keyboard.isDown("down") then
			engine.camera:move("down", 100 * dt)
		end

		if love.keyboard.isDown("left") then
			engine.camera:move("left", 100 * dt)
		end

		if love.keyboard.isDown("right") then
			engine.camera:move("right", 100 * dt)
		end

		if love.keyboard.isDown("up") then
			engine.camera:move("up", 100 * dt)
		end

	end

end

function game.resize(w, h)

end

function game.mousepressed(x, y, button)

	lightMouse = engine.map.lightworld:newLight(engine.camera:getMouseX(), engine.camera:getMouseY(), 255, 255, 255, 300)

end
 
function game.mousereleased(x, y, button)

end
 
function game.keypressed(key, unicode)

	if engine.state:isCurrentState("game") then

		engine.chat.keypressed(key, unicode)

	end

end
 
function game.keyreleased(key)

end

function game.textinput(text)

	if engine.state:isCurrentState("game") then

		engine.chat.textinput(text)
		
	end

end

return game