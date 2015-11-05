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

local server = {}
local net = require 'engine.libs.LUBE'

function server.start(port)

	if not CLIENT then

		print('[network] Starting server ...')

		server.internal = net.lubeServer()
		server.internal.handshake = "80085"
		server.internal:listen(port or "18025")

		server.internal.callbacks.connect = server.onConnect or function()
			print('[network] Player connected, but a handler does not exist (make one) [network.server.onConnect(id)].')
		end

		server.internal.callbacks.recv = server.onReceive or function()
			print('[network] Packet received, but a handler does not exist (make one) [network.server.onReceive(packet, id)].')
		end

		server.internal.callbacks.disconnect = server.onDisconnect or function()
			print('[network] Player disconnected, but a handler does not exist (make one) [network.server.onDisconnect(id)].')
		end

		SERVER = true

	else

		error('[network] Can\'nt start Server when Client is running')

	end

end

function server.update(dt)

	server.internal:update(dt)

end

function server.send(name, data, id)

	if SERVER then

		local packet = {
			name = name,
			data = data
		}

		local packagedtbl = json.encode(packet)

		if id then
			server.internal:send(packagedtbl, id)
		else
			server.internal:send(packagedtbl)
		end

	end

end

return server