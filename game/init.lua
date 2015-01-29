game = {}

function game.load()

	-- Set default state --
	engine.state.setState("splash")

	-- Splash Screen --
	engine.splash.addSplash(love.graphics.newImage("game/data/images/splashes/love.png"))
	engine.splash.onComplete(function() engine.state.setState("menu") end)

	-- Debug Vars --
	engine.debug.addVar("global.version", function() return engine.global.version end)
	engine.debug.addVar("state.currentState", function() return engine.state.currentState end)

end

function game.draw()

end

function game.update(dt)

end

return game