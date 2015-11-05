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

local game = {}
game.path = ... .. '.'

function game.load(args)

	print('[console] Loading developer console ...')
	game.console = require('game.console'):new(true)
	print('[console] Loaded developer console!')

	print('[resources] Loading UI Classes ...')
	game.ui = require.tree('game.ui', true)
	print('[resources] Loaded UI Classes!')

	function network.server.onConnect(id)
		print(id)
	end

	function network.server.onReceive(packet, id)

		packet = json.decode(packet)
		
		print(packet.data)
		network.server.send('pong', 'PONG', id)

	end

	function network.client.onReceive(packet)

		packet = json.decode(packet)

		print(packet.data)
		network.client.send('ping', 'PING')

	end

	if args['--dedicated'] then
		network.server.start()
	else
		network.client.start()
	end

	if CLIENT then

		love.graphics.setBackgroundColor(200, 200, 200)

		-- local frame = ui.Create("frame")
		-- frame:SetName("Connect")
		-- frame:ShowCloseButton(false)
		-- frame:SetSize(210, 150)
		-- frame:Center()

		-- local usernameInput = ui.Create("textinput", frame)
		-- usernameInput:SetPos(5, 30)
		-- usernameInput:SetPlaceholderText("Username")

		-- local ipInput = ui.Create("textinput", frame)
		-- ipInput:SetPos(5, 60)
		-- ipInput:SetPlaceholderText("IP Address")

		-- local button = ui.Create("button", frame)
		-- button:SetPos(5, 90)
		-- button:SetSize(200, 55)
		-- button:SetText("Connect")

		-- button.OnClick = function(object, x, y)
		-- 	local success = network.client.connect(ipInput:GetText())
		-- 	if success then
		-- 		network.client.send("ping", "PING")
		-- 		frame:Remove()
		-- 	end
		-- end

	end

	game.ui.options:show()

end

function game.update(dt)

	network.update(dt)

end

function game.draw()

end

function game.keypressed(key, isrepeat)

	if key == '`' and not game.console.input:GetFocus() then game.console:toggle() end

end

return game