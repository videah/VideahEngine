local path = (...):match("(.-)[^%.]+$") .. '.'
local class = require(path .. "util.middleclass")
local util = require(path .. "util.util")
local Base = require(path .. "base")

local Var = class("Var", Base)

function Var:initialize(var, settings)

	Base.initialize(self, var, settings)

	if type(self.var) == "string" then self.name = self.var end

	self.name = settings.name or self.name or "Variable"

	self.font = self.settings.font or love.graphics.newFont(16)
	self.width = self.font:getWidth("HurpDurp")
	self.height = self.font:getHeight()

	print("    Created Variable Object")
end

function Var:draw()

	self:Align()

	love.graphics.setFont(self.font)

	love.graphics.setColor(0, 0, 0)

	love.graphics.print(self.name .. ": ", self.x + self.panelx, self.y + self.panely)
	love.graphics.print(self:getVar(), (self.x + self.font:getWidth(self.name .. ": ")) + self.panelx, self.y + self.panely)

	self.width = self.font:getWidth(self.name .. ": ") + self.font:getWidth(self:getVar())

	love.graphics.setColor(255, 255, 255)

end

return Var