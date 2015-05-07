local path = (...):match("(.-)[^%.]+$") .. '.'
local class = require(path .. "util.middleclass")
local util = require(path .. "util.util")

local Base = class("Base")

function Base:initialize(var, settings)

	self.settings = settings

	self.var = var

	self.x = self.settings.x or 0
	self.y = self.settings.y or 0

	self.panelx = self.settings.panelx or 0
	self.panely = self.settings.panely or 0
	self.panelw = self.settings.panelw or 0
	self.panelh = self.settings.panelh or 0

	self.offseth = self.settings.offseth or 0
	self.offsetv = self.settings.offsetv or 0

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

function Base:setPanelSize(w, h)

	self.panelw = w or 0
	self.panelh = h or 0

end

function Base:getVar()

	local variable = self.var

	if type(variable) == "function" then

		return variable()

	elseif type(variable) == "string" then

		return util.getGlobalFromName(variable)

	else

		return variable

	end

end

function Base:Align()

	if self.settings.align == "left" then
		-- No need to do anything.
	elseif self.settings.align == "center" then
		self:setPos((self.panelw / 2) - (self.width / 2), self.y)
	elseif self.settings.align == "right" then
		self:setPos((self.panelw - self.width) - self.offseth, self.y)
	end

end

function Base:draw()

end

function Base:update(dt)

end

return Base