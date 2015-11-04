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

local console = {}
local defaultPrint = print

function console.load(hookPrint)

	console.frame = ui.Create("frame")
	console.frame:SetName("Console")
	console.frame:SetSize(700, 500)

	console.frame:SetMinWidth(200)
	console.frame:SetMinHeight(200)

	console.frame:SetMaxWidth(10000)
	console.frame:SetMaxHeight(10000)

	console.frame:SetResizable(true)
	console.frame:Center()

	w, h = console.frame:GetSize()

	console.list = ui.Create("list", console.frame)
	console.list:SetPos(10, 30)
	console.list:SetSize(w - 20, h - 90)
	console.list:SetAutoScroll(true)

	console.buffer = {}

	console.input = ui.Create("textinput", console.frame)
	console.input:SetSize((w - 20) - 85, 35)
	console.input:SetPos(10, h - 45)
	console.input:SetFont(love.graphics.newFont('engine/assets/fonts/Varela-Regular.otf', 14))

	console.button = ui.Create("button", console.frame)
	console.button:SetSize(75, 35)
	console.button:SetPos(w - 85, h - 45)
	console.button:SetText("Enter")

	console.input.OnEnter = function(object)

		console.runCommand(console.input:GetText())
		console.input:Clear()

	end

	console.button.OnClick = console.input.OnEnter

	console.frame:SetVisible(false)
	console.frame.OnResize = function(object, width, height)

		console.list:SetSize(width - 20, height - 90)
		console.input:SetSize((width - 20) - 85, 35)

		console.list:SetPos(10, 30)
		console.input:SetPos(10, height - 45)

		console.button:SetSize(75, 35)
		console.button:SetPos(width - 85, height - 45)

	end

	console.frame.OnClose = function(object)
		console.toggle()
		return false
	end
	
	if hookPrint then
		print = function(...)
			console.print(...)
			defaultPrint(...)
		end
	end

end

function console.toggle()

	local toggleVis = not console.frame:GetVisible()
	console.frame:SetVisible(toggleVis)

end

function console.print(text, color)

	local line = ui.Create("text", console.list)
	line:SetDetectLinks(true)
	line:SetText(text)

	table.insert(line, console.buffer)

end

function console.clear()

	console.list:Clear()

end

function console.runCommand(text)

	print('] ' .. text)

end

return console