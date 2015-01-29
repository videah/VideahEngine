engine 	= require 'engine'
game 	= require 'game'

function love.load()

	engine.load()
	game.load()

end

function love.draw()

	game.draw()
	engine.draw()

end

function love.update(dt)

	engine.update(dt)
	game.update(dt)

end
