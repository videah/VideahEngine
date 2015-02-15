local network = {}
lube = require(engine.path .. 'libs.LUBE')

network._port = "18025"
network._ip = "127.0.0.1"

network.client = {}
network.server = {}


function network.startServer()

	function network.onConnect(ip, port)

		print("Client connected.")

	end

	function network.onReceive(data, ip, port)

		print("Received data: " .. data)

	end

	function network.onDisconnect(ip, port)

		print("Client disconnected.")

	end

	network.serv = lube.tcpServer()
	network.serv:listen(network._port)
	network.serv:setPing(true, 16, "areYouStillThere?\n")
	network.serv.callbacks.connect = network.onConnect
	network.serv.callbacks.recv = network.onReceive
	network.serv.callbacks.disconnect = network.onDisconnect
	network.serv.handshake = "Hi!"
	print("Successfully started server on port " .. network._port)

end

function network.startClient()

	function network.onReceive(data)

		print(data)

	end

	network.cli = lube.tcpClient()
	network.cli.handshake = "Hi!"
	network.cli.callbacks.recv = network.onReceive
	network.cli:setPing(true, 2, "areYouStillThere?\n")
	print("Loaded client ...")

end

if SERVER then

	network.startServer()

	function network.update(dt)

		network.serv:update(dt)

	end

	function network.server.send(data)

		network.serv:send(data)

	end

end

if CLIENT then

	network.startClient()

	function network.update(dt)

		network.cli:update(dt)

	end

	function network.client.connect(ip, port)

		local sucess, err = network.cli:connect(ip, port)

		if err ~= nil then
			print("Error connecting to " .. ip .. " (" .. err .. ")")
		end

		if sucess then
			print("Successfully connected to " .. ip .. "!")
		end

	end

	function network.client.disconnect()

		network.cli:disconnect()

		print("Disconnected client from server.")

	end

	function network.client.send(data)

		network.cli:send(data)

	end

end

return network