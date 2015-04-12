local client = {}
local lube = require(engine.path .. 'libs.LUBE')
local serial = require(engine.path .. 'util.serial')

client._id = nil
client._connected = false

function client.start()

	client._cli = lube.tcpClient()
	client._cli.handshake = "997067"
	client._cli.callbacks.recv = client.onReceive
	print("Loaded client ...")

	engine.network._hasLoaded = true

end

-----------------
--  CALLBACKS  --
-----------------

function client.onReceive(data)

	local ok, packet = serial.load(data)

	if packet.ptype == "c" then

		if packet.playername == nil then

			print("Server: " .. packet.data.msg)

		else

			print(packet.playername .. ": " .. packet.data.msg)

		end

		engine.chat.say(packet.data.msg, packet.playername)

	elseif packet.ptype == "si" then

		if packet.data.numofplayers > packet.data.maxplayers then
			engine.console.error("Could not connect to server: Server Full")
			client.disconnect("Server Full")
			return
		end

		if packet.data.mapname then

			print("Successfully joined server: " .. packet.data.servername)

			print("Server is currently running on the map " .. packet.data.mapname)

			success = engine.map.loadmap(packet.data.mapname)

			if not success then
				client.disconnect("Error loading map.")
			end

		else

			engine.console.error("The server is currently not running a map.")
			client.disconnect("The server is currently not running a map.")

		end

	end

end

-----------------
--  FUNCTIONS  --
-----------------

function client.send(data)

	local tbl = data
	local packagedtbl = serial.dump(tbl)
	client._cli:send(packagedtbl)

end

function client.say(msg)

	local packet = {

		ptype = "c",
		playername = game.playername,
		data = {

			msg = msg

		}

	}

	client.send(packet)

end

function client.connect(ip, port)

	if client._connected then
		client.disconnect("Changing server.")
	end

	local success, err = client._cli:connect(ip, port)

	client._id = engine.network.generateID(16)

	if err ~= nil then
		print("Error connecting to " .. ip .. " (" .. err .. ")")
		return
	end

	if success then
		print("Successfully connected to " .. ip .. "!")
		client._connected = true
	end

	local tbl = {ptype = "join", playerid = client._id, playername = game.playername}

	client.send(tbl)

end

function client.disconnect(reason)

	local tbl = {ptype = "dc", reason = reason, playername = game.playername, playerid = client._id}

	client.send(tbl)

	--client._cli:disconnect() -- Currently not working, waiting on LUBE being fixed.

end

function client.isConnected()
	return client._connected
end

return client