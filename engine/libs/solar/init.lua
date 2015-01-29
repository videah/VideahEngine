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
solar.namelist = {}
solar.functionlist = {}

solar.x = 15
solar.y = 15
solar.width = 250
solar.height = 34

local theme = require(path .. '/themes/' .. theme)

function solar.addVar(name, variable)

	assert(type(variable) == "function", "variable must be in function form")

	table.insert(solar.namelist, name)

	table.insert(solar.functionlist, variable)

end

function solar.removeVar(name)

	for i=1, #solar.namelist do

		if solar.namelist[i] == name then
			table.remove(solar.namelist, i)
			table.remove(solar.functionlist, i)
			break
		end

	end

end

function solar.draw()

	local highestwidth = 0

	for i=1, #solar.namelist do

		local lengthstring = tostring(solar.namelist[i] .. ": " .. solar.functionlist[i]())

		if theme.font:getWidth(lengthstring) > highestwidth then
			highestwidth = theme.font:getWidth(lengthstring)
		end

	end

	solar.width = 15 + highestwidth

	love.graphics.setColor(theme.panelbg)
	love.graphics.rectangle("fill", solar.x, solar.y, solar.width, (theme.font:getHeight() * (#solar.namelist) + #solar.namelist))
	love.graphics.setColor(255,255,255,255)

	for i=1, #solar.namelist do

		local name = solar.namelist[i]
		local func = solar.functionlist[i]()

		love.graphics.setFont(theme.font)

		love.graphics.print(name .. ":", solar.x + 4, (solar.y + 4) + (theme.font:getHeight() * (i - 1)))

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

		love.graphics.print(func, theme.font:getWidth(name) + solar.x + 12, (solar.y + 4) + (theme.font:getHeight() * (i - 1)))

		love.graphics.setColor(255,255,255)

	end

end

return solar