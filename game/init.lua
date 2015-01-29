game = {}

function game.load()

	-- Set default state --
	engine.state.setState("splash")

	-- Splash Screen --
	--engine.splash.addSplash(love.graphics.newImage("game/data/images/splashes/love.png"))
	engine.splash.onComplete(function() engine.state.setState("menu") end)

	-- Debug Vars --
	engine.debug.addVar("global.version", function() return engine.global.version end)
	engine.debug.addVar("state.currentState", function() return engine.state.currentState end)

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