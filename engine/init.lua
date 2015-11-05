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

require 'engine.libs.require'

local engine = {}

class = require 'engine.libs.class'

function engine.load(args)

	hook = require 'engine.modules.hook'
	network = require 'engine.modules.network'

	if love.graphics then ui = require 'engine.libs.LoveFrames' end
	json = require 'engine.libs.json'
	lume = require 'engine.libs.lume'

	cpml = require 'engine.libs.cpml'

	-- Model Loaders
	model = {}
	model.iqm = require 'engine.libs.iqm'
	model.obj = require 'engine.libs.obj'
	model.iqe = require 'engine.libs.iqe'

	require('engine.libs.love3d').import(true, true)

end

function engine.update(dt)

	if CLIENT then ui.update(dt) end

end

function engine.draw()

	ui.draw()

end

function engine.mousepressed(x, y, button)

	ui.mousepressed(x, y, button)

end

function engine.mousereleased(x, y, button)

	ui.mousereleased(x, y, button)

end

function engine.wheelmoved(x, y)

	ui.wheelmoved(x, y)

end

function engine.keypressed(key, isrepeat)

	ui.keypressed(key, isrepeat)

end

function engine.keyreleased(key)

	ui.keyreleased(key)

end

function engine.textinput(text)

	ui.textinput(text)

end

function engine.textedited(t, s, l)


end

function engine.resize(w, h)

end

function engine.focus(focus)

end

return engine