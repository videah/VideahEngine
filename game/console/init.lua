-- This code is licensed under the MIT Open Source License.

-- Copyright (c) 2015 Ruairidh Carmichael - ruairidhcarmichael@live.co.uk

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the 'Software'), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local UI = require 'game.classes.ui'

local Console = class('Console', UI)

local defaultPrint = print

function Console:initialize(hookPrint)

	UI.initialize(self, 'Console', false)

	self.frame:SetSize(700, 500)
	self.frame:Center()

	w, h = self.frame:GetSize()

	self.list = ui.Create('list', self.frame)
	self.list:SetPos(10, 30)
	self.list:SetSize(w - 20, h - 90)
	self.list:SetAutoScroll(true)

	self.buffer = {}

	self.input = ui.Create('textinput', self.frame)
	self.input:SetSize((w - 20) - 85, 35)
	self.input:SetPos(10, h - 45)
	self.input:SetFont(love.graphics.newFont('engine/assets/fonts/Varela-Regular.otf', 14))

	self.button = ui.Create('button', self.frame)
	self.button:SetSize(75, 35)
	self.button:SetPos(w - 85, h - 45)
	self.button:SetText('Enter')

	self.input.OnEnter = function(object)

		self:runCommand(self.input:GetText())
		self.input:Clear()

	end

	self.button.OnClick = self.input.OnEnter

	self.frame:SetVisible(false)
	self.frame.OnResize = function(object, width, height)

		self.list:SetSize(width - 20, height - 90)
		self.input:SetSize((width - 20) - 85, 35)

		self.list:SetPos(10, 30)
		self.input:SetPos(10, height - 45)

		self.button:SetSize(75, 35)
		self.button:SetPos(width - 85, height - 45)

	end

	self.frame.OnClose = function(object)
		self:toggle()
		return false
	end
	
	if hookPrint then
		print = function(...)
			self:print(...)
			defaultPrint(...)
		end
	end

end

function Console:print(text, color)

	local line = ui.Create('text', self.list)
	line:SetDetectLinks(true)
	line:SetText(text)

	table.insert(line, self.buffer)

end

function Console:clear()

	self.list:Clear()

end

function Console:runCommand(text)

	print('] ' .. text)

end

return Console