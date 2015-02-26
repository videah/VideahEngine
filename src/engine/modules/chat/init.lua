local path = ... .. "."

local chat = {}
local config = require(path .. "config")

local chatStack = {}
local chatHistoryStack = {}

local chatInput = ""

local chatFocused = true

local function drawText(text, x, y, r, sx, sy, ox, oy, kx, ky)

	local red, green, blue, alpha = love.graphics.getColor()
	local darkencolor = {0, 0, 0, 255}

	love.graphics.setColor(darkencolor)
	love.graphics.print(text, x + 1, y + 1, r, sx, sy, ox, oy, kx, ky)
	love.graphics.setColor(red, green, blue, alpha)
	love.graphics.print(text, x, y, r, sx, sy, ox, oy, kx, ky)

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

	if #chatStack == 0 then return end

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

		drawText(chatInput, x + 4, y + height - 29)

	end

	love.graphics.setFont(config.font)

	for i=1, #chatStack do

		local height = y + ((i - 1) * config.font:getHeight())

		local message = tostring(chatStack[i].message)
		local player = tostring(chatStack[i].player)

		love.graphics.setFont(config.bigfont)

		drawText(player .. ": ", x, height)

		love.graphics.setFont(config.font)

		local fontdiff = (config.bigfont:getHeight() / 2) - (config.font:getHeight() / 2)

		drawText(message, x + config.bigfont:getWidth(player .. ": "), height + fontdiff)

		love.graphics.setColor(255, 255, 255, 255)

	end

end

function chat.textinput(s)

	if chatFocused then
		chatInput = chatInput .. s
	end

end

chat.say("This is a test message.", "module.chat")

return chat