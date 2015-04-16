local path = (...):match("(.-)[^%.]+$") .. '.'
local class = require(path .. "util.middleclass")

local Base = class("Base")

function Base:initialize(var, settings)

	self.settings = settings

	self.var = var

	self.x = self.settings.x or 0
	self.y = self.settings.y or 0

	self.panelx = self.settings.panelx or 0
	self.panely = self.settings.panely or 0

	self.width = self.settings.width or 0
	self.height = self.settings.height or 0

	print("")
	print("Created Base Object ¬")

end

function Base:setPos(x, y)

	self.x = x or 0
	self.y = y or 0

end

function Base:setPanelPos(x, y)

	self.panelx = x or 0
	self.panely = y or 0

end

function Base:draw()

end

function Base:update(dt)

end

return Base