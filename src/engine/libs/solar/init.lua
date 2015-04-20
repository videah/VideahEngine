-- This code is licensed under the MIT Open Source License.

-- Copyright (c) 2015 Ruairidh Carmichael - ruairidhcarmichael@live.co.uk

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

---------------------------------------------------------
-- Don't edit below unless you know what you're doing. --
---------------------------------------------------------

local path = ... .. '.'
local class = require(path .. "objects.util.middleclass")

local Solar = class("Solar")

function Solar:initialize(x, y, settings)

	self.settings = settings or {}

	self.x = x or 0
	self.y = y or 0

	self.width = 200
	self.height = 200

	self.objects = {}

	self.theme = require(path .. "themes." .. settings.theme) or nil

	print(string.format("Created debug panel at: X:%s Y:%s", self.x, self.y))

	self:newObject(function() return _G.fps end, "var")



end

function Solar:setPos(x, y)

	self.x = x or 0
	self.y = y or 0

end

function Solar:draw()

	self.width = 0

	local finalheight = 0
	local offseth = self.theme.gap_horizontal or 0
	local offsetv = self.theme.gap_vertical or 0

	for i, object in ipairs(self.objects) do

		finalheight = finalheight + (object.height + offsetv)

		if object.width > self.width then
			self.width = object.width
		end

	end

	self.width = self.width + (offseth * 2)
	self.height = finalheight + offsetv

	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

	for i, object in ipairs(self.objects) do
		object:setPanelPos(self.x, self.y)
		object:setPos(offseth, (object.height * (i - 1)) + (offsetv * i))
		object:draw()
	end

end

function Solar:update(dt)

	for i, objects in ipairs(self.objects) do
		object:update(dt)
	end

end

function Solar:newObject(var, obj, settings)

	obj = obj or "text"

	settings = settings or {}
	settings.panelx, settings.panely = self.x, self.y

	-- Defaults --
	settings.font = settings.font or self.theme.font

	local objclass = require(path .. "objects." .. obj)

	table.insert(self.objects, objclass:new(var, settings))

end

return Solar