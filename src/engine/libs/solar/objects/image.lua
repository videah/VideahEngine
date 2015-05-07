local path = (...):match("(.-)[^%.]+$") .. '.'
local class = require(path .. "util.middleclass")
local util = require(path .. "util.util")
local Base = require(path .. "base")

local Image = class("Image", Base)

function Image:initialize(var, settings)

	Base.initialize(self, var, settings)

	self.image = self:getVar()

	self.angle = self.settings.angle or 0
	self.scalex = self.settings.scalex or 1
	self.scaley = self.settings.scaley or 1

	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	print("     Created Image Object")

end

function Image:draw()

	self.image = self:getVar()

	self:Align()

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(self.image, self.x + self.panelx, self.y + self.panely, self.angle, self.scalex, self.scaley)

	self.width = self.image:getWidth() * self.scalex
	self.height = self.image:getHeight() * self.scaley

	love.graphics.setColor(255, 255, 255)

end

function Image:update(dt)

end

return Image