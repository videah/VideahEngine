local network = {}
local lube = require(engine.path .. 'libs.LUBE')
local serial = require(engine.path .. 'util.serial')

network._port = "18025"
network._ip = "127.0.0.1"

network.client = {}
network.client._id = nil
network.client._connected = false

network.server = {}
network.server.playerlist = {}

local hasLoaded = false

-- Utility --

local function generateID(length)

	local charset = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" -- Characters
	local s = "" -- Create a blank string
	local tbl = {} -- Create a table to hold randomized charset

	for i=1, #charset do
		tbl[i] = string.sub(charset, i, i) -- Insert individual charset characters into the table
	end

	for i=#charset, 2, -1 do
		local r = math.random(i)
		tbl[i], tbl[r] = tbl[r], tbl[i] -- Randomly swap the charset around
	end

	for i=1, length do
		r = math.random(#charset)
		s = s .. tbl[r] -- Add a random character to the string
	end

	return s -- Finally, return the randomly generated string
end

-- Server Callbacks --

function network.server.onConnect(id)

end

function network.server.onReceive(data, id)

	local ok, packet = serial.load(data)

	if ok == nil then

		engine.console.error("Corrupt packet received: " .. packet)
		return

	end
	
	if packet.ptype == "join" then -- a Player has joined the server.

		print('Player ' .. packet.playername .. " (ID: " .. packet.playerid .. ") has joined the game")

		local playerinfo = {name = packet.playername, id = packet.playerid}

		table.insert(network.server.playerlist, playerinfo)

		local infopacket = {

			ptype = "si",
			data = {

				mapname = engine.map.currentmapname

			}

		}

		network.server.send(infopacket, id)

	elseif packet.ptype == "dc" then -- a Player has left the server.

		print('Player ' .. packet.playername .. " has left the game. (Reason: " .. packet.reason .. ")")

	elseif packet.ptype == "c" then -- a Player has sent a chat message.

		print(packet.playername .. ": " .. packet.data.msg) -- Print the message to the server console.

		network.server.send(packet) -- Send the message to all clients, including the sender.

	else

		engine.console.error("Unknown packet received.")

	end

end

function network.server.onDisconnect(id)

	print("Client disconnected.")

end

-- Client Callbacks --

function network.client.onReceive(data)

	local ok, packet = serial.load(data)

	if packet.ptype == "c" then

		if packet.playername == nil then

			print("Server: " .. packet.data.msg)

		else

			print(packet.playername .. ": " .. packet.data.msg)

		end

		engine.chat.say(packet.data.msg, packet.playername)

	elseif packet.ptype == "si" then

		if packet.data.mapname then

			print("Server is currently running on the map" .. packet.data.mapname)

		else

			engine.console.error("The server is currently not running a map.")
			network.client.disconnect("The server is currently not running a map.")

		end

	end

end

function network.startServer(gui)

	network.serv = lube.tcpServer()
	network.serv:listen(network._port)
	--network.serv:setPing(true, 16, "PING")
	network.serv.callbacks.connect = network.server.onConnect
	network.serv.callbacks.recv = network.server.onReceive
	network.serv.callbacks.disconnect = network.server.onDisconnect
	network.serv.handshake = "997067"

	if gui then

		network.loadGUI()

	end

	function love.keypressed(key, isrepeat)

		engine.console.keypressed(key, isrepeat)

	end

	engine.console.success("Successfully started server on port " .. network._port)

	hasLoaded = true

end

function network.startClient()

	network.cli = lube.tcpClient()
	network.cli.handshake = "997067"
	network.cli.callbacks.recv = network.client.onReceive
	--network.cli:setPing(true, 2, "PING")
	print("Loaded client ...")

	hasLoaded = true

end

-- Server Functions

function network.server.send(data, id)

	id = id or nil

	local tbl = data
	local packagedtbl = serial.dump(tbl)
	if id == nil then
		network.serv:send(packagedtbl)
	else
		network.serv:send(packagedtbl, id)
	end

end

function network.server.say(msg)

	print("Server: " .. msg)

	local packet = {

		ptype = "c",
		playername = nil,
		data = {

			msg = msg

		}

	}

	network.server.send(packet)

end

function network.server.status()

	print("Number of Players: " .. engine.network.server.getNumberOfPlayers() .. "/" .. "?")

	print(serial.block(engine.network.server.playerlist))

end

function network.server.getNumberOfPlayers()

	return #engine.network.server.playerlist

end

-- Client Functions --

function network.client.send(data)

	local tbl = data
	local packagedtbl = serial.dump(tbl)
	network.cli:send(packagedtbl)

end

function network.client.say(msg)

	local packet = {

		ptype = "c",
		playername = game.playername,
		data = {

			msg = msg

		}

	}

	network.client.send(packet)

end

function network.client.connect(ip, port)

	local success, err = network.cli:connect(ip, port)

	network.client._id = generateID(16)

	if err ~= nil then
		print("Error connecting to " .. ip .. " (" .. err .. ")")
		return
	end

	if success then
		print("Successfully connected to " .. ip .. "!")
		network.client._connected = true
	end

	local tbl = {ptype = "join", playerid = network.client._id, playername = game.playername}

	network.client.send(tbl)

end

function network.client.disconnect(reason)

	local tbl = {ptype = "dc", reason = reason, playername = game.playername}

	network.client.send(tbl)

	--network.cli:disconnect() -- Currently not working, waiting on LUBE being fixed.

end

function network.client.isConnected()
	return network.client._connected
end

-- Update --

function network.update(dt)

	if SERVER and hasLoaded then
		network.serv:update(dt)
	end

	if CLIENT and hasLoaded then
		network.cli:update(dt)
	end

end

function network.loadGUI()

	function love.draw()

		engine.ui.draw()
		engine.console.draw()

	end

	function love.update(dt)

		engine.ui.update(dt)
		network.serv:update(dt)

	end

	local frame = engine.ui.Create("frame")
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)

	local playerlpanel = engine.ui.Create("panel", frame)
	local messagepanel = engine.ui.Create("panel", frame)
	local consolepanel = engine.ui.Create("panel", frame)

	local playerlist = engine.ui.Create("columnlist", playerlpanel)
	playerlist:AddColumn("Name")
	playerlist:AddColumn("Ping")

	local console = engine.ui.Create("list", consolepanel)
	console:SetPadding(5)

	local textinput = engine.ui.Create("textinput", messagepanel)
	local inputfont = love.graphics.newFont(16)
	textinput:SetFont(inputfont)
	textinput.OnEnter = function(object, text)

		if text ~= "" then
			engine.console.perform(text)
		end
		textinput:Clear()
	end

	local submitbutton = engine.ui.Create("button", messagepanel)
	submitbutton:SetText("Submit")
	submitbutton.OnClick = function()

		if textinput:GetText() ~= "" then
			engine.console.perform(textinput:GetText())
		end
		textinput:Clear()

	end

	local function editObjectProperties()

		--- Panels ---

		-- Frame --
		frame:SetName("VideahEngine " .. _G.version .. " Server")
		frame:SetSize(_G.screenWidth, _G.screenHeight)

		-- Player List --
		playerlpanel:SetSize(250, _G.screenHeight - 35)
		playerlpanel:SetPos(_G.screenWidth - playerlpanel:GetWidth() - 5, 30)

		-- Text Input --
		messagepanel:SetSize(_G.screenWidth - playerlpanel:GetWidth() - 15, 50)
		messagepanel:SetPos(5, _G.screenHeight - messagepanel:GetHeight() - 5)

		-- Console --
		consolepanel:SetSize(_G.screenWidth - playerlpanel:GetWidth() - 15, _G.screenHeight - messagepanel:GetHeight() - 40)
		consolepanel:SetPos(5, 30)

		--- Objects ---

		-- Player List --
		playerlist:SetSize(playerlpanel:GetWidth(), playerlpanel:GetHeight())

		-- Console --
		console:SetSize(consolepanel:GetWidth(), consolepanel:GetHeight())

		-- Text Input --
		textinput:SetSize(messagepanel:GetWidth(), messagepanel:GetHeight())

		-- Submit Button --
		submitbutton:SetSize(150, messagepanel:GetHeight())
		submitbutton:SetPos(messagepanel:GetWidth() - submitbutton:GetWidth(), 0)

		engine.console.receiveInput(false)
		engine.console.setPosition(5, 30)
		engine.console.setSize(console:GetWidth(), console:GetHeight())

	end

	editObjectProperties()

	function love.resize(w, h)

		_G.screenWidth = w
		_G.screenHeight = h

		editObjectProperties()

	end

	local real_print = print

	_G["print"] = function(...)

		real_print(...)

		local printobject = engine.ui.Create("text")
		printobject:SetText(...)

		console:AddItem(printobject)

	end

end


return network