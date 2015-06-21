local network = {}

local path = ... .. "."

network._port = "18025"
network._hasLoaded = false

network.client = require(path .. "client")
network.server = require(path .. "server")

-- Utility --

function network.generateID(length)

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

-- Update --

function network.update(dt)

	if SERVER and network._hasLoaded then
		network.server._serv:update(dt)
		network.server.update(dt)
	end

	if CLIENT and network._hasLoaded then
		network.client._cli:update(dt)
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