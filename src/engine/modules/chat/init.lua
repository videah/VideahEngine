local function getPath()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)") or ""
end

local path = getPath()

local chat = {}
local config = require(path .. "config")

local chatStack = {}
local chatHistoryStack = {}
local chatEmotes = {}

local chatInput = ""
local chatFocused = false

if config.emotes.enabled then

	local chatEmoteFiles = love.filesystem.getDirectoryItems(path .. "emotes")

	for k, file in ipairs(chatEmoteFiles) do
		name = string.gsub(file, "colon", ":")
		name = string.gsub(name, ".png", "")
		print(name)
		if file ~= "Thumbs.db" then -- I hate these things.
			chatEmotes[#chatEmotes + 1] = {
			name = name,
			image = love.graphics.newImage(path .. "emotes/" .. file)
			}
		end
	end
end

local function drawText(text, x, y, r, sx, sy, ox, oy, kx, ky)

	local red, green, blue, alpha = love.graphics.getColor()
	local darkencolor = {0, 0, 0, 255}

	love.graphics.setColor(darkencolor)
	love.graphics.print(text, x + 1, y + 1, r, sx, sy, ox, oy, kx, ky)
	love.graphics.setColor(red, green, blue, alpha)
	love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)

end

function string.insert(s1, s2, pos)
	return string.sub(s1, 1, pos) ..s2 ..string.sub(s1, pos + 1, #s1)
end

-- Drop a character a certain position.
function string.pop(str, pos)
	return string.sub(str, 1, pos) ..string.sub(str, pos + 2, #str)
end

-- Remove all UTF8 characters from a string.
function string.stripUTF8(str)
	return str:gsub('[%z\1-\127\194-\244][\128-\191]*', function(c) return #c > 1 and "" end)
end

local function difference(a, b)

	if a > b then
		r = a - b
	else
		r = b - a
	end

	return r

end

function chat.say(message, player)
	if message == nil then return end

	player = player or "Server"

	if #chatStack > config.maximumChatLines then
		table.remove(chatStack, 1)
	end

	chatStack[#chatStack + 1] = {

	player = player,
	message = message

	}
end

function chat.draw()

	config.chatPositionX = 15
	config.chatPositionY = _G.screenHeight - config.chatHeight - 15

	local x, y = config.chatPositionX, config.chatPositionY
	local width, height = config.chatWidth, config.chatHeight

	if chatFocused then

		love.graphics.setColor(config.color.bg)
		love.graphics.rectangle("fill", x, y, width, height)

		love.graphics.setColor(config.color.textbox)
		love.graphics.rectangle("fill", x + 4, y + height - 29, width - 8, 25)
		love.graphics.setColor(255, 255, 255, 255)

		love.graphics.setFont(config.font)

		drawText(chatInput, x + 8, y + height - 29)

		if math.ceil(os.clock() * config.cursorSpeed) % 2 == 0 then
			drawText("|", config.font:getWidth(chatInput) + (x + 8), y + height - 29)
		else
			drawText(" ", config.font:getWidth(chatInput) + (x + 8), y + height - 29)
		end

	end

	love.graphics.setFont(config.font)

	for i=1, #chatStack do

		local height = y + ((i - 1) * config.font:getHeight())

		local message = tostring(chatStack[i].message)
		local player = tostring(chatStack[i].player)

		love.graphics.setFont(config.bigfont)

		drawText(player .. ": ", x + 4, height)

		love.graphics.setFont(config.font)

		local fontdiff = (config.bigfont:getHeight() / 2) - (config.font:getHeight() / 2)

		if config.emotes.enabled then

			for k=1, #chatEmotes do
				for word in string.gmatch(message, "%a+") do
					if word == chatEmotes[k].name then
						message = string.gsub(message, word, "  ")
					end
				end

				for word in string.gmatch(message, ":.") do
					if word == chatEmotes[k].name then
						message = string.gsub(message, word, "  ")
					end
				end
			end
		end

		drawText(message, (x + 4) + config.bigfont:getWidth(player .. ": "), height + fontdiff)

		love.graphics.setColor(255, 255, 255, 255)

	end

	chat.drawEmotes()

end

function chat.keypressed(key, unicode)

	if chatFocused then
		if key == "return" then
			if string.sub(chatInput, 0, 1) == "/" then
				engine.console.perform(string.sub(chatInput, 2, string.len(chatInput)))
				chatInput = ""
				chatFocused = false
			elseif chatInput ~= "" then
				if engine.network.client.isConnected() then
					engine.network.client.say(chatInput)
				else
					engine.chat.say(chatInput, game.playername)
				end
				chatInput = ""
				chatFocused = false
			else
				chatInput = ""
				chatFocused = false
			end
		elseif key == "backspace" then
			if string.len(chatInput) ~= 0 then
				chatInput = string.pop(chatInput, string.len(chatInput) - 1)
			end
		end
		if love.keyboard.isDown("lctrl", "rctrl") and love.keyboard.isDown("v") then
			chatInput = string.insert(chatInput, love.system.getClipboardText(), string.len(chatInput))
		end
	else

		if key == "return" then
			chatFocused = true
		end

	end
end

function chat.textinput(s)

	if chatFocused then
		chatInput = string.insert(chatInput, s, string.len(chatInput))
	end

end

function chat.drawEmotes()

	if config.emotes.enabled == false then return end

	local x, y = config.chatPositionX, config.chatPositionY

	for k=1, #chatStack do
		for i=1, #chatEmotes do

			local numofemotes = 0

			local message = tostring(chatStack[k].message)
			local player = tostring(chatStack[k].player)
			local height = y + ((k - 1) * config.font:getHeight())

			local start, finish = string.find(chatStack[k].message, chatEmotes[i].name)

			for word in string.gmatch(message, "%a+") do
				if word == chatEmotes[i].name then
					numofemotes = numofemotes + 1
				end
			end

			for word in string.gmatch(message, ":.") do
				if word == chatEmotes[i].name then
					numofemotes = numofemotes + 1
				end
			end

			message = string.gsub(message, chatEmotes[i].name, "")
			for j=1, numofemotes do
				if string.find(chatStack[k].message, chatEmotes[i].name) ~= nil then

					message = string.sub(message, 0, start - 1)

					local width = config.font:getWidth(player .. ": " .. message) + (chatEmotes[i].image:getWidth() * j)
					love.graphics.draw(chatEmotes[i].image, width, height)
				end
			end
			numofemotes = 0
		end
	end
end

-- function chat.drawEmotes()

-- 	local x, y = config.chatPositionX, config.chatPositionY
-- 	local emoteAmount = 0

-- 	for i=1, #chatStack do

-- 		local message = chatStack[i].message
-- 		local player = chatStack[i].player

-- 		for k=1, #chatEmotes do

-- 			local start, finish = string.find(chatStack[i].message, chatEmotes[k].name)

-- 			for word in string.gmatch(message, "%a+") do
-- 				if word == chatEmotes[k].name then
-- 					emoteAmount = emoteAmount + 1
-- 				end
-- 			end

-- 			local emotey = y + ((i - 1) * config.font:getHeight())


-- 			for j=1, emoteAmount do

-- 				if string.find(message, chatEmotes[k].name) ~= nil then

-- 					message = string.gsub(message, chatEmotes[i].name, "")

-- 					message = string.sub(message, 0, start - 1)

-- 					local emotex = config.font:getWidth(player .. ": " .. message) + (chatEmotes[k].image:getWidth() * j)
-- 					--emotex = emotex - config.font:getWidth(chatEmotes[k].name)

-- 					love.graphics.draw(chatEmotes[k].image, emotex, emotey)

-- 				end

-- 			end

-- 		end

-- 	end

-- end

--chat.say("This is a test message.", "module.chat")

return chat
