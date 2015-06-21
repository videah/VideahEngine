local client = {}
local lube = require(engine.path .. 'libs.LUBE')
local serial = require(engine.path .. 'util.serial')

client._id = nil
client._CONNECTED = false

client.playerlist = {}
client.entitylist = {}

function client.start()

	client._cli = lube.tcpClient()
	client._cli.handshake = "997067"
	client._cli.callbacks.recv = client.onReceive
	print("Loaded client ...")

	network._hasLoaded = true

end

-----------------
--  CALLBACKS  --
-----------------

function client.onReceive(data)

	local ok, packet = serial.load(data)

	if ok == nil then

		console.error("Corrupt packet received: " .. packet)
		return

	end

	if packet.ptype == "c" then

		if packet.playername == nil then

			print("Server: " .. packet.data.msg)

		else

			print(packet.playername .. ": " .. packet.data.msg)

		end

		game.chat:say(packet.data.msg, packet.playername)

	elseif packet.ptype == "si" then

		if packet.data.numofplayers > packet.data.maxplayers then
			console.error("Could not connect to server: Server Full")
			client.disconnect("Server Full")
			return
		end

		if packet.data.mapname then

			print("Successfully joined server: " .. packet.data.servername)

			client.playerlist = packet.data.playerlist

			print(packet.data.playerlist)

			print("Server is currently running on the map " .. packet.data.mapname)

			success = map.loadmap(packet.data.mapname)

			if not success then
				client.disconnect("Error loading map.")
			end

		else

			console.error("The server is currently not running a map.")
			client.disconnect("The server is currently not running a map.")

		end

	elseif packet.ptype == "track" then

		local ent = entity.create(packet.entname)
		ent.id = packet.id
		ent.name = packet.name or nil
		ent.updatevars = vars

		for i=1, #packet.data do

			ent[vars[i]] = packet.data[vars[i]]

		end

		table.insert(client.entitylist, ent)

	elseif packet.ptype == "eup" then

		for i=1, #packet.data do
			for j=1, #client.entitylist do
				if packet.data[i].name == client.entitylist[i].name or packet.data[i].id == client.entitylist[i].id then
					for k=1, #packet.data[i].updatevars do
						local var = packet.data[i].updatevars[k]
						client.entitylist[i][var] = packet.data[i].values[var]
					end
				end
			end
		end

	end

end

-----------
--  DRAW --
-----------

function client.draw()

	for i=1, #client.entitylist do

		client.entitylist[i]:draw()

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

	if client._CONNECTED then
		client.disconnect("Changing server.")
	end

	local success, err = client._cli:connect(ip, port)

	client._id = network.generateID(16)

	if err ~= nil then
		print("Error connecting to " .. ip .. " (" .. err .. ")")
		return
	end

	if success then
		print("Successfully connected to " .. ip .. "!")
		client._CONNECTED = true
	end

	local tbl = {ptype = "join", playerid = client._id, playername = game.playername}

	client.send(tbl)

end

function client.disconnect(reason)

	local tbl = {ptype = "dc", reason = reason, playername = game.playername, playerid = client._id}

	client.send(tbl)

	client._cli:disconnect() -- Currently not working, waiting on LUBE being fixed.

end

function client.isConnected()
	return client._CONNECTED
end

function client.drawScoreBoard()

	local width = 500
	local height = 250

	local x = (_G.screenWidth / 2) - (width / 2)
	local y = (_G.screenHeight / 2) - (height / 2)

	love.graphics.setColor(50, 50, 50)
	love.graphics.rectangle("fill", x, y, width, height)
	love.graphics.setColor(255, 255, 255)

	for i, player in ipairs(client.playerlist) do
		love.graphics.print(player.name, x + 25, y + (25 * i))
	end

end

return client