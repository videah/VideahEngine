local path = ... .. '.'

local input = {}
input.list = {}

input.keyboard = {}
input.mouse = {}

-- TODO: Work on implementing these.
input.gamepad = {}
input.touch = {}

-- Binds --

function input.keyboard.bind(key, action)

	for i=1, #input.list do

		if input.list[i].action == action then
			table.remove(input.list, i)
		end

	end

	local tbl = {key = key, action = action, inputtype = "keyboard"}
	table.insert(input.list, tbl)

end

function input.mouse.bind(key, action)

	for i=1, #input.list do

		if input.list[i].action == action then
			table.remove(input.list, i)
		end

	end

	local tbl = {key = key, action = action, inputtype = "mouse"}
	table.insert(input.list, tbl)

end

function input.gamepad.bind(key, action)

	for i=1, #input.list do

		if input.list[i].action == action then
			table.remove(input.list, i)
		end

	end

	local tbl = {key = key, action = action, inputtype = "gamepad"}
	table.insert(input.list, tbl)

end

-- Input --

function input.keyboard.isDown(action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if input.list[i].inputtype == "keyboard" then
				if love.keyboard.isDown(input.list[i].key) then
					return true
				else
					return false
				end
			end
		end
	end
end

function input.mouse.isDown(action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if input.list[i].inputtype == "mouse" then
				if love.mouse.isDown(input.list[i].key) then
					return true
				else
					return false
				end
			end
		end
	end
end

return input