game = {}
game.path = ... .. '/'

function game.load()

	-- Set default state --
	engine.state.setState("splash")

	-- Splash Screen --
	engine.splash.addSplash(love.graphics.newImage("game/data/images/splashes/love.png"))
	engine.splash.onComplete(function() engine.state.setState("menu") end)

	-- Debug Vars --
	engine.debug.addVar("FPS", function() return global.fps end)
	engine.debug.addVar("global.version", function() return engine.global.version end)
	engine.debug.addVar("state.currentState", function() return engine.state.currentState end)
	engine.debug.addVar("global.mousex", function() return engine.global.cursorx end)
	engine.debug.addVar("global.mousey", function() return engine.global.cursory end)

	-- Menu Buttons --
	engine.menu.addButton("Start", 0, 0, function() engine.state.setState("game") end)
	engine.menu.addButton("Quit", 0, 0, function() love.event.quit() end)

end

function game.draw()

	if engine.state:isCurrentState("menu") then
		engine.menu.draw()
	end

end

function game.update(dt)

	if engine.state:isCurrentState("menu") then
		engine.menu.update(dt)
	end

end

return game