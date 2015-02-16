require 'engine/util/debug' -- Temporary debug console

CLIENT = false
SERVER = false

game 	= require 'game'
engine 	= require 'engine'

-- You should never have to touch anything in here.
-- Edit the init.lua in both the games and engine folder instead.

function love.load(arg)

	for i, v in ipairs(arg) do

		if v == "-debug" then
			_G.debug = true
		else
			_G.debug = false
		end

		if v == "-dedicated" then
			SERVER = true
		else
			CLIENT = false
		end
		
	end

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

function love.resize(w, h)

	engine.resize(w, h)

end

function love.mousepressed(x, y, button)

	engine.mousepressed(x, y, button)

end
 
function love.mousereleased(x, y, button)

	engine.mousereleased(x, y, button)

end
 
function love.keypressed(key, unicode)

	engine.keypressed(key, unicode)

end
 
function love.keyreleased(key)

	engine.keyreleased(key)

end

function love.textinput(text)

	engine.textinput(text)

end