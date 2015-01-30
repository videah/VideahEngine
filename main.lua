--require 'engine/util/debug' -- Temporary debug console

game 	= require 'game'
engine 	= require 'engine'

-- You should never have to touch anything in here.
-- Edit the init.lua in both the games and engine folder instead.

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
