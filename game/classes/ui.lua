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

local UI = class('UI')

function UI:initialize(title, showOnCreate, hardClose)

	self.frame = ui.Create('frame')
	self.frame:SetVisible(showOnCreate or false)
	self.frame:SetName(title)
	self.frame:SetResizable(true)

	self.frame:SetMinWidth(200)
	self.frame:SetMinHeight(200)

	self.frame:SetMaxWidth(10000)
	self.frame:SetMaxHeight(10000)

	self.frame.OnClose = function(object)
		self:hide()
		return false
	end

end

function UI:setState(state)

	self.frame:MakeTop()
	self.frame:SetVisible(state)

end

function UI:show()

	self:setState(true)

end

function UI:hide()

	self:setState(false)

end

function UI:toggle()

	local toggleVis = not self.frame:GetVisible()
	self:setState(toggleVis)

end

return UI