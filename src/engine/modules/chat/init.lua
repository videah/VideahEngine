-- I'll probably redo this AGAIN someday.

local chat = {}

chat.ChatLine = engine.class("ChatLine")

function chat.ChatLine:initialize(string, x, y, width, height, owner)

	self.text = string

	self.owner = owner
	self.x = x
	self.y = y

	self.width = width or 10000
	self.height = height or 10000

end

function chat.ChatLine:setPos(x, y)

	self.x, self.y = x, y

end

function chat.ChatLine:draw()

	engine.graphics.printc(string.format("[white]%s: %s", self.owner, self.text), self.x, self.y, self.width, nil, self.height, nil, {border = true})

end

chat.ChatBox = engine.class("ChatBox")

function chat.ChatBox:initialize(x, y, width, height, options)

	self.options = options or {}
	self.font = self.options.font or love.graphics.setNewFont(18)

	self.x = x
	self.y = y

	self.width = width
	self.height = height

	self.maxlines = 100
	self.maxDisplayLines = math.floor((self.height / self.font:getHeight()))

	self.active = true

	self.buffer = {}

	self.index = 1

	local chatEmoteFiles = love.filesystem.getDirectoryItems("engine/modules/chat/emotes")

	for k, file in ipairs(chatEmoteFiles) do
		local name = string.gsub(file, ".png", "")
		print(name)
		if file ~= "Thumbs.db" then -- I hate these things.
			engine.graphics.printc[name] = function()

				local img = love.graphics.newImage('engine/modules/chat/emotes/' .. file)
				return {size = {self.font:getHeight(), self.font:getHeight()}, draw = function(x, y) love.graphics.draw(img, x, y, 0.0, self.font:getHeight() / img:getHeight(), self.font:getHeight() / img:getWidth()) end, appendSpace = true}

			end
		end
	end

end

function chat.ChatBox:say(message, player)

	if message == nil then return end

	player = player or "Server"

	self:isBufferFull()

	if #self.buffer >= self.maxDisplayLines and self.index > #self.buffer - self.maxDisplayLines then
		self.index = self.index + 1
	end

	self.buffer[#self.buffer + 1] = chat.ChatLine:new(message, self.x, self.y, self.width, self.font:getHeight(), player)

end

function chat.ChatBox:mousepressed(x, y, button)

	if self.active then

		if button == "wd" and self.index < #self.buffer then
			self.index = self.index + 1
		end

		if button == "wu" and self.index > 1 then
			self.index = self.index - 1
		end

	end

end

function chat.ChatBox:draw()

	if self.active then

		local lineheight = 0

		love.graphics.setColor(26, 26, 26, 155)
		love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setFont(self.font)
		
		for i, line in ipairs(self.buffer) do
			if i >= self.index and i < self.index + self.maxDisplayLines then
				line:setPos(self.x, self.y + lineheight)
				lineheight = lineheight + self.font:getHeight()
				line:draw()
				love.graphics.setColor(255, 255, 255, 255)
			end
		end

	end

end

function chat.ChatBox:toggle()

	self.active = not self.active

end

function chat.ChatBox:isBufferFull()

	if #self.buffer > self.maxlines then
		table.remove(self.buffer, 1)
	end

end

return chat