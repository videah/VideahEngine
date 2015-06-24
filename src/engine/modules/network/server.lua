local server = {}
local lube = require(engine.path .. 'libs.LUBE')
local serial = require(engine.path .. 'util.serial')

server.playerlist = {}
server.entitylist = {}

local t = 0

function server.start(port, gui)

	server.cfg = cfg.load("server")

	server.name = server.cfg.settings.name or "VideahServer"
	server.maxplayers = server.cfg.settings.maxplayers or 16
	server.map = server.cfg.settings.map

	love.window.setTitle(server.name)

	server._serv = lube.lubeServer()
	server._serv:listen(network._port)
	server._serv.callbacks.connect = server.onConnect
	server._serv.callbacks.recv = server.onReceive
	server._serv.callbacks.disconnect = server.onDisconnect
	server._serv.handshake = "997067"

	if gui then
		network.loadGUI()
	end

	function love.keypressed(key, isrepeat)

		console.keypressed(key, isrepeat)

	end

	map.loadmap(server.map)

	console.success("Successfully started server on port " .. network._port)

	network._hasLoaded = true

end

-----------------
--  CALLBACKS  --
-----------------

function server.onConnect(id)

end

function server.onReceive(data, id)

	local ok, packet = serial.load(data)

	hook.Call("ServerOnReceive", packet)

	if ok == nil then

		console.error("Corrupt packet received: " .. packet)
		return

	end
	
	if packet.ptype == "join" then -- a Player has joined the server.

		hook.Call("OnPlayerJoin", packet)

		print('Player ' .. packet.playername .. " (ID: " .. packet.playerid .. ") has joined the game")

		local playerinfo = {name = packet.playername, id = packet.playerid}

		table.insert(server.playerlist, playerinfo)

		local infopacket = {

			ptype = "si",
			data = {

				servername = server.name,
				numofplayers = server.getNumberOfPlayers(),
				maxplayers = server.maxplayers,
				mapname = map.currentmapname,
				playerlist = server.playerlist

			}

		}

		server.send(infopacket, id)

		server.track(entity.create("player"), {"x", "y"}, packet.playername, packet.playername)

	elseif packet.ptype == "dc" then -- a Player has left the server.

		hook.Call("OnPlayerDisconnect", packet)

		packet.reason = packet.reason or "disconnect"

		print('Player ' .. packet.playername .. " has left the game. (Reason: " .. packet.reason .. ")")

		for i, player in ipairs(server.playerlist) do
			if packet.playerid == player.id then
				table.remove(server.playerlist, i)
				break
			end
		end

	elseif packet.ptype == "c" then -- a Player has sent a chat message.

		print(packet.playername .. ": " .. packet.data.msg) -- Print the message to the server console.

		server.send(packet) -- Send the message to all clients, including the sender.

	elseif packet.ptype == "em" then

		hook.Call("OnNetworkedEntityModify")

		local modEntity

		for i=1, #server.entitylist do
			local ent = server.entitylist[i]
			if ent.id == packet.id or ent.name == packet.name then
				modEntity = packet.name or packet.id
			end
		end

		if packet.type == "player" then

			if packet.action == "player_up" and packet.status == true then

				server.setEntityVar(packet.id, "y", server.getEntityVar(packet.id, "y") - 5)

			end

			if packet.action == "player_down" and packet.status == true then

				server.setEntityVar(packet.id, "y", server.getEntityVar(packet.id, "y") + 5)

			end

			if packet.action == "player_left" and packet.status == true then

				server.setEntityVar(packet.id, "x", server.getEntityVar(packet.id, "x") - 5)

			end

			if packet.action == "player_right" and packet.status == true then

				server.setEntityVar(packet.id, "x", server.getEntityVar(packet.id, "x") + 5)

			end

		end

	else

		console.error("Unknown packet received.")

	end

end

function server.onDisconnect(id)

end

--------------
--  UPDATE  --
--------------

function server.update(dt)

	local updatepacket = {

		ptype = "eup",
		data = {}

	}

	t = t + dt

	if t > (1 / server.cfg.settings.tickrate) then

		for i=1, #server.entitylist do

			local ent = {}
			ent.name = server.entitylist[i].name or nil
			ent.id = server.entitylist[i].id
			ent.updatevars = server.entitylist[i].updatevars
			ent.values = {}

			for j=1, #server.entitylist[i].updatevars do
				local var = server.entitylist[i].updatevars[j]
				ent.values[var] = server.entitylist[i][var]
			end

			updatepacket.data[i] = ent

		end

		server.send(updatepacket)

		t = t - (1 / server.cfg.settings.tickrate)

	end

end

-----------------
--  FUNCTIONS  --
-----------------

function server.send(data, id)

	id = id or nil

	local tbl = data
	local packagedtbl = serial.dump(tbl)
	if id == nil then
		server._serv:send(packagedtbl)
	else
		server._serv:send(packagedtbl, id)
	end

end

function server.say(msg)

	print("Server: " .. msg)

	local packet = {

		ptype = "c",
		playername = nil,
		data = {

			msg = msg

		}

	}

	server.send(packet)

end

function server.track(entity, vars, name, owner)

	entity.id = #server.entitylist + 1
	entity.name = name or nil
	entity.updatevars = vars
	entity.owner = owner or nil

	table.insert(server.entitylist, entity)

	local packet = {

		ptype = "track",
		entname = entity.type,
		id = entity.id,
		name = entity.name,
		vars = vars,
		data = {}

	}

	for i=1, #vars do
		packet.data[vars[i]] = entity[vars[i]]
	end

	server.send(packet)

end

function server.untrack(entity)

	for i=1, #server.entitylist do
		if server.entitylist[i].name == entity or server.entitylist[i].id == entity then
			table.remove(server.entitylist, i)
		end
	end

	local packet = {

		ptype = "utrack",
		entity = entity

	}

	server.send(packet)

end

function server.getEntityVar(entity, var)

	for i=1, #server.entitylist do
		local ent = server.entitylist[i]
		if ent.id == entity or ent.name == entity then
			return ent[var]
		end
	end

end

function server.setEntityVar(entity, var, value)

	for i=1, #server.entitylist do
		local ent = server.entitylist[i]
		if ent.id == entity or ent.name == entity then
			server.entitylist[i][var] = value
		end
	end

end

function server.status()

	print("Number of Players: " .. server.getNumberOfPlayers() .. "/" .. server.maxplayers)

	for i, player in ipairs(server.playerlist) do
		print(i .. "	" .. player.name .. " (" .. player.id .. ")")
	end

end

function server.getNumberOfPlayers()

	return #server.playerlist

end

return server