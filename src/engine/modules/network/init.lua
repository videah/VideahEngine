local network = {}
lube = require(engine.path .. 'libs.LUBE')

network._port = "18025"
network._ip = "127.0.0.1"

network.client = {}
network.server = {}

local hasLoaded = false

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

	hasLoaded = true

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

	hasLoaded = true

end

if SERVER then

	network.startServer()

	function network.server.send(data)

		network.serv:send(data)

	end

end

if CLIENT then

	network.startClient()

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

function network.update(dt)

	if SERVER and hasLoaded then
		network.serv:update(dt)
	end

	if CLIENT and hasLoaded then
		network.cli:update(dt)
	end

end

return network