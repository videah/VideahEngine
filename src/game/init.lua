game = {}
game.path = ... .. '/'
game.playername = "Untitled Player"

function game.load()

	game.panel = panel:new(15, 15, {theme = "monokai"})

	game.chat = chat.ChatBox:new(15, _G.screenHeight - 315, 500, 300)
	game.chat:say("This is a test message.", "Test Person")
	game.chat:say("The new chatbox [red] supports [green] colors [blue] :D", "Test Person")
	game.chat:say("And emotes [Kappa] [colonv]", "Test Person")
	game.chat:say("You can even color emotes!", "Test Person")
	game.chat:say("[red][colonv] [green][colonv] [blue][colonv]", "Test Person")

	-- Player Bindings --
	input.keyboard.bind("w", "player_up")
	input.keyboard.bind("s", "player_down")
	input.keyboard.bind("a", "player_left")
	input.keyboard.bind("d", "player_right")

	-- Create the Camera --

	game.camera = camera:new(0, 0, 1, true)

	-- Create the Player --
	game.player = entity.create("player", 0, 0, 50, 50)

	-- Set default state --
	state.setState("splash")

	-- Splash Screen --
	splash.addSplash(graphics.newImage("game/data/images/splashes/videahenginesplash.png"))
	splash.addSplash(graphics.newImage("game/data/images/splashes/love.png"))
	splash.onComplete(function() state.setState("menu") end)

	-- Debug Vars --
	-- panel.addVar("FPS", function() return _G.fps end)
	-- panel.addVar("player.x", function() returngame.player.x end)
	-- panel.addVar("player.y", function() returngame.player.y end)
	--input.mouse.bind("l", "click")

	-- Menu Buttons --
	menu.addButton("Start", 0, 0, function() state.setState("game") end)
	menu.addButton("Options", 0, 0, function() print("TODO: Add options menu.") end)
	menu.addButton("Quit", 0, 0, function() love.event.quit() end)

end

function game.draw()

	if state:isCurrentState("menu") then	
		menu.draw()
	end

	if state:isCurrentState("game") then

		game.camera:set()

		map.lightworld:draw(function()

			map.draw()

		game.player:draw()

		end)

			-- Game Draw Code Here --

		game.camera:unset()

		game.chat:draw()

		if love.keyboard.isDown("tab") then
			network.client.drawScoreBoard()
		end

	end

	game.panel:draw()

end

function game.update(dt)

	if state:isCurrentState("menu") then
		menu.update(dt)
	end

	if state:isCurrentState("game") then
		game.camera:update(dt)

		map.lightworld:update(dt)
		map.lightworld:setTranslation(game.camera:getX(), game.camera:getY(), game.camera:getScale())

		if love.keyboard.isDown("down") then
			game.camera:move("down", 100 * dt)
		end

		if love.keyboard.isDown("left") then
			game.camera:move("left", 100 * dt)
		end

		if love.keyboard.isDown("right") then
			game.camera:move("right", 100 * dt)
		end

		if love.keyboard.isDown("up") then
			game.camera:move("up", 100 * dt)
		end

	game.player:update(dt)

	end

end

function game.resize(w, h)

end

function game.mousepressed(x, y, button)

	local result = game.chat:mousepressed(x, y, button)

	if result then return end

	lightMouse = map.lightworld:newLight(game.camera:getMouseX(), game.camera:getMouseY(), 255, 255, 255, 300)

end
 
function game.mousereleased(x, y, button)

end
 
function game.keypressed(key, unicode)

	if state:isCurrentState("game") then

		if key == "escape" then state.setState("menu") end
		if key == "return" then game.chat:toggle() end

	end

end
 
function game.keyreleased(key)

end

function game.textinput(text)

	if state:isCurrentState("game") then


		
	end

end

return game