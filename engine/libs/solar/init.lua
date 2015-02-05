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

---------------------------------------------
-- Set this to true to enable color theme. --
---------------------------------------------

local enableTheme = true
local theme = 'monokai'

---------------------------------------------------------
-- Don't edit below unless you know what you're doing. --
---------------------------------------------------------

local path = ...

local solar = {}
solar.list = {}

solar.x = 15
solar.y = 15
solar.width = 250
solar.height = 34

local theme = require(path .. '/themes/' .. theme)

function solar.addVar(name, variable)

	assert(type(variable) == "function", "variable must be in function form")

	local tbl = {name = name, func = variable, format = "var"}

	table.insert(solar.list, tbl)

end

function solar.removeVar(name)

	for i=1, #solar.list do

		if solar.list[i].name == name then
			table.remove(solar.list, i)
			break
		end

	end

end

function solar.addWheel(name, variable)

	assert(type(variable) == "function", "variable must be in function form")

	local tbl = {name = name, func = variable, format = "wheel"}

	table.insert(solar.list, tbl)

end

function solar.draw()

	local highestwidth = 0

	local numberofvars = 0
	local numberofwheels = 0

	-- Resize panel to biggest var width. --

	for i=1, #solar.list do

		local lengthstring = tostring(solar.list[i].name .. ": " .. solar.list[i].func())

		if theme.font:getWidth(lengthstring) > highestwidth then
			highestwidth = theme.font:getWidth(lengthstring)
		end

	end

	solar.width = 15 + highestwidth

	-- Find how many types of objects --

	for i=1, #solar.list do
		if solar.list[i].format == "var" then
			numberofvars = numberofvars + 1
		elseif solar.list[i].format == "wheel" then
			numberofwheels = numberofwheels + 1
		end
	end

	local panelheight = 0

	panelheight = theme.font:getHeight() * (numberofvars)
	panelheight = panelheight + (theme.font:getHeight() * (numberofwheels)) + (70 * numberofwheels) + 4

	love.graphics.setColor(theme.panelbg)
	love.graphics.rectangle("fill", solar.x, solar.y, solar.width, panelheight)
	love.graphics.setColor(255,255,255,255)

	local objectheight = (solar.y + 4) - theme.font:getHeight()

	for i=1, #solar.list do

		local name = solar.list[i].name
		local func = solar.list[i].func()
		local format = solar.list[i].format

		if format == "var" then

			objectheight = objectheight + theme.font:getHeight()

			love.graphics.setFont(theme.font)

			love.graphics.print(name .. ":", solar.x + 4, objectheight)

			-- Variable highlighting --
			if enableTheme then
				if func == "true" then
					love.graphics.setColor(theme.boolean_true)
				elseif func == "false" then
					love.graphics.setColor(theme.boolean_false)
				elseif type(func) == "string" then
					love.graphics.setColor(theme.string)
				elseif type(func) == "number" then
					love.graphics.setColor(theme.number)
				end
			end

			-- Pretty quotations --
			if func ~= "true" and func ~= "false" then
				if type(func) == "string" then
					func = '"' .. func .. '"'
				end
			end

			love.graphics.print(func, theme.font:getWidth(name) + solar.x + 12, objectheight)

			love.graphics.setColor(255,255,255)

		elseif format == "wheel" then

			objectheight = objectheight + theme.font:getHeight()

			love.graphics.print(name .. ":", solar.x + 4, objectheight)

			objectheight = objectheight + theme.font:getHeight()

			love.graphics.circle("line", (solar.x + 4) + 35, objectheight + 35, 35, 20 )

			objectheight = (objectheight + 50)

		end

	end

end

return solar