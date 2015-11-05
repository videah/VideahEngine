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

local client = {}
local net = require 'engine.libs.LUBE'

client.connected = false

function client.start()

	if not SERVER then

		print('[network] Starting client ...')

		client.internal = net.lubeClient()
		client.internal.handshake = "80085"

		client.internal.callbacks.recv = client.onReceive or function() 
			error('Packet received, but a handler does not exist (make one) [network.client.onReceive].')
		end

		print('[network] Successfuly started client!')

		CLIENT = true

	else

		error('[network] Can\'nt start Client when Server is running')

	end

end

function client.update(dt)

	if client.internal then

		client.internal:update(dt)

	end

end

function client.connect(ip, port)

	port = port or "18025"

	print('[network] Attempting to connect to ' .. ip .. ':' .. port .. ' ...')

	if CLIENT then

		if client.connected then
			client.disconnect('Changing server.')
		end

		local success, err = client.internal:connect(ip, port)

		if err then
			print('[network] Error connecting to ' .. ip .. ' (' .. err .. ')')
			return false
		end

		if success then
			print('[network] Successfully connected to ' .. ip .. ':' .. port .. '!')
			client.connected = true
			return true
		end

	else

		print('[network] Error connecting to ' .. ip .. ' (Client isn\'t running)')
		return false

	end

end

function client.disconnect(reason)

	if CLIENT then

		print('[network] Disconnecting from server ...')

		client.internal:disconnect()

	end

end

function client.send(name, data)

	if CLIENT then

		local packet = {
			name = name,
			data = data
		}

		local packagedtbl = json.encode(packet)
		client.internal:send(packagedtbl)

	end

end

return client