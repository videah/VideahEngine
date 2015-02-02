game = {}
game.path = ... .. '/'

function game.load()

	-- Set default state --
	engine.state.setState("splash")

	-- Splash Screen --
	--engine.splash.addSplash(love.graphics.newImage("game/data/images/splashes/love.png"))
	engine.splash.onComplete(function() engine.state.setState("menu") end)

	-- Debug Vars --
	engine.debug.addVar("FPS", function() return global.fps end)
	engine.debug.addVar("global.version", function() return engine.global.version end)
	engine.debug.addVar("state.currentState", function() return engine.state.currentState end)
	engine.debug.addVar("global.mousex", function() return engine.global.cursorx end)
	engine.debug.addVar("global.mousey", function() return engine.global.cursory end)

	-- Menu Buttons --
	engine.menu.addButton("Button", 0, 0, "Button", "Button")
	engine.menu.addButton("Button", 0, 0, "Button", "Button")
	engine.menu.addButton("Button", 0, 0, "Button", "Button")
	engine.menu.addButton("Button", 0, 0, "Button", "Button")
	engine.menu.addButton("Button", 0, 0, "Button", "Button")

	engine.input.bind(" ", "print_test")
	engine.input.bind("l", "mouse_test") -- Mouse
	engine.input.bind("a", "gamepad_test")

end

function game.draw()

	if engine.state:isCurrentState("menu") then
		engine.menu.draw()
	end

	if engine.input.gamepad.isDown("gamepad_test") then
		engine.input.gamepad.pads[1]:setVibration(0.25, 0.25)
	else
		engine.input.gamepad.pads[1]:setVibration(0, 0)
	end

end

function game.update(dt)

	if engine.state:isCurrentState("menu") then
		engine.menu.update(dt)
	end

end

return game