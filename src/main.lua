CLIENT = false
SERVER = false

game 	= require 'game'
engine 	= require 'engine'

-- You should never have to touch anything in here.
-- Edit the init.lua in both the games and engine folder instead.

function love.load(arg)

	local args = {}
	for i, v in ipairs(arg) do
		args[v] = true
	end

	if args["-dedicated"] then
		SERVER = true
	else
		CLIENT = true
	end

	engine.load()
	game.load()

	if CLIENT then
		engine.network.startClient()
	end

	if SERVER then
		if args["-gui"] then
			engine.network.startServer(true)
		else
			engine.network.startServer(false)
		end
	end

	if args["-debug"] then
		_G.debugmode = true
	end

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
	game.resize(w, h)

end

function love.mousepressed(x, y, button)

	engine.mousepressed(x, y, button)
	game.mousepressed(x, y, button)

end
 
function love.mousereleased(x, y, button)

	engine.mousereleased(x, y, button)
	game.mousereleased(x, y, button)

end
 
function love.keypressed(key, unicode)

	engine.keypressed(key, unicode)
	game.keypressed(key, unicode)

end
 
function love.keyreleased(key)

	engine.keyreleased(key)
	game.keyreleased(key)

end

function love.textinput(text)

	engine.textinput(text)
	game.textinput(text)

end

function love.quit()

	if CLIENT then
		engine.network.client.disconnect()
	end

	if SERVER then
		engine.network.server.send("shutdown")
	end

	print("Shutting down ...")

end