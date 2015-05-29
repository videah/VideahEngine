local path = (...):match("(.-)[^%.]+$") .. '.'
local class = require(path .. "util.middleclass")
local util = require(path .. "util.util")
local Base = require(path .. "base")

local Bar = class("Bar", Base)

function Bar:initialize(var, settings)

	Base.initialize(self, var, settings)

	if type(self.var) == "string" then self.name = self.var end

	self.name = settings.name or self.name or "Variable"

	self.font = self.settings.font or love.graphics.newFont(16)
	self.color = self.settings.color or {0, 0, 0, 255}
	self.dens = self.settings.thickness or 4

	if self.settings.shouldDrawText ~= nil then
		self.shouldDrawText = self.settings.shouldDrawText
	else
		self.shouldDrawText = true
	end

	self.min = self.settings.min or 0
	self.max = self.settings.max or 100

	self.width = self.settings.width or self.panelw
	self.height = self.settings.height or 50

	print("     Created Bar Object")

end

function Bar:drawBorder(x, y, width, height, dens, color)

	love.graphics.rectangle("fill", x, y, dens, height)

	love.graphics.rectangle("fill", x, y, width, dens)

	love.graphics.rectangle("fill", x, y + height - dens, width, dens)

	love.graphics.rectangle("fill", x + width - dens, y, dens, height)

end

function Bar:drawText(string, x, y)

	love.graphics.setColor(0, 0, 0, 255)

	love.graphics.print(string, x - 1, y)
	love.graphics.print(string, x + 1, y)
	love.graphics.print(string, x, y - 1)
	love.graphics.print(string, x, y + 1)

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.print(string, x, y)

end

function Bar:draw()

	if self.settings.width == nil then
		self.width = self.panelw - self.offseth * 2
	end

	love.graphics.setColor(self.color)
	love.graphics.setFont(self.font)

	self:Align()

	local barWidth = (self:getVar() - self.min) / self.max

	if barWidth < 0 then
		barWidth = 0
	elseif barWidth > 1 then
		barWidth = 1
	end

	love.graphics.rectangle("fill", self.x + self.panelx, self.y + self.panely, self.width * barWidth, self.height)

	self:drawBorder(self.x + self.panelx, self.y + self.panely, self.width, self.height, self.dens)

	if self.shouldDrawText then

		local finalText = self.name .. ": " .. self:getVar()

		self:drawText(finalText,
		(self.x + self.panelx) + (self.width / 2) - (self.font:getWidth(finalText) / 2), 
		(self.y + self.panely) + (self.height / 2) - (self.font:getHeight() / 2))

	end

	if self.settings.width == nil then
		self.width = 0
	end

end

return Bar