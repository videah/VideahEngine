local path = (...):match("(.-)[^%.]+$") .. '.'
local class = require(path .. "util.middleclass")
local Base = require(path .. "base")

local Text = class("Text", Base)

function Text:initialize(var, settings)

	self.settings = settings

	self.text = var

	self.font = self.settings.font
	self.width = self.font:getWidth(self.text)
	self.height = self.font:getHeight()

	Base:initialize(self, Text, settings)

	print("     Created Text Object")

end

function Text:draw()

	love.graphics.setFont(self.font)

	love.graphics.setColor(math.random(1, 255), math.random(1, 255), math.random(1, 255))

	love.graphics.print(self.text, self.x + self.panelx, self.y + self.panely)

	love.graphics.setColor(255, 255, 255)

end

function Text:update(dt)

end

return Text