game = {}

function game.load()

	engine.splash.addSplash(love.graphics.newImage("game/data/images/splashes/love.png"))

	engine.debug.addVar("test", function() return engine.global.version end)

end

function game.draw()

end

function game.update(dt)

end

return game