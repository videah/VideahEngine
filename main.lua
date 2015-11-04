-- This code is licensed under the MIT Open Source License.

-- Copyright (c) 2015 Ruairidh Carmichael - ruairidhcarmichael@live.co.uk

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

engine	 = require('engine')
game	 = require('game')

function love.load(arg)

	local args = {}
	for i, v in ipairs(arg) do
		args[v] = true
	end

	if love.graphics then screenWidth, screenHeight = love.graphics.getDimensions() end

	engine.load(args)
	game.load(args)

end

function love.update(dt)

	game.update(dt)
	engine.update(dt)

end

function love.draw()

	if love.graphics then

		game.draw()
		engine.draw()

	end

end

function love.mousepressed(x, y, button)

	engine.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)

	engine.mousereleased(x, y, button)

end

function love.wheelmoved(x, y)

	engine.wheelmoved(x, y)

end

function love.keypressed(key, isrepeat)

	engine.keypressed(key, isrepeat)
	game.keypressed(key, isrepeat)

end

function love.keyreleased(key)

	engine.keyreleased(key)

end

function love.textinput(text)

	engine.textinput(text)

end

function love.textedited(t, s, l)

	engine.textedited(t, s, l)

end

function love.resize(w, h)

	screenWidth, screenHeight = w, h
	engine.resize(w, h)

end

function love.focus(focus)

	engine.focus(focus)

end