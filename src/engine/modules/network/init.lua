local network = {}
lube = require(engine.path .. 'libs.LUBE')

network._port = "18025"
network._ip = "127.0.0.1"

network.client = {}
network.server = {}

local hasLoaded = false

function network.startServer(gui)

	SERVER = true

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

	if gui then

		function love.draw()

			engine.ui.draw()

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
    		print("[SERVER]: " .. text)
    		network.server.send("[SERVER]: " .. text)
    		textinput:Clear()
		end

		local submitbutton = engine.ui.Create("button", messagepanel)
		submitbutton:SetText("Submit")
		submitbutton.OnClick = function()

			print("[SERVER]: " .. textinput:GetText())
    		network.server.send("[SERVER: " .. text)
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

		print("Successfully started server on port " .. network._port)

	end

	hasLoaded = true

end

function network.startClient()

	CLIENT = true

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

-- Server Functions

function network.server.send(data)

	network.serv:send(data)

end

-- Client Functions --

function network.client.connect(ip, port)

	local sucess, err = network.cli:connect(ip, port)

	if err ~= nil then
		print("Error connecting to " .. ip .. " (" .. err .. ")")
		return
	end

	if sucess then
		print("Successfully connected to " .. ip .. "!")
	end

	network.client.send("N: " .. game.playername)

end

function network.client.disconnect()

	network.cli:disconnect()

	print("Disconnected client from server.")

end

function network.client.send(data)

	network.cli:send(data)

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