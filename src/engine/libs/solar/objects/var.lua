local path = (...):match("(.-)[^%.]+$") .. '.'
local class = require(path .. "util.middleclass")
local Base = require(path .. "base")

local Var = class("Var", Base)

function Var:initialize(var, settings)

	self.settings = settings

	self.font = self.settings.font
	self.height = self.font:getHeight()

	Base:initialize(self, var, settings)

	print("    Created Variable Object")
end

function Var:draw()

	love.graphics.setFont(self.font)

	love.graphics.setColor(math.random(1, 255), math.random(1, 255), math.random(1, 255))

	love.graphics.print("HurpDurp", self.x + self.panelx, self.y + self.panely)

	love.graphics.setColor(255, 255, 255)

end

function Var:update(dt)

end

return Var