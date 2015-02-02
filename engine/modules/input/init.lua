input = {}
input.list = {}

input.keyboard = {}
input.keyboard.hasBeenPressed = false

input.mouse = {}
input.mouse.hasBeenPressed = false

function input.bind(key, action)

	for i=1, #input.list do

		if input.list[i].action == action then
			table.remove(input.list, i)
		end

	end

	local tbl = {key = key, action = action}
	table.insert(input.list, tbl)

end

-- Keyboard --

function input.keyboard.isDown(action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if love.keyboard.isDown(input.list[i].key) then
				return true
			else
				return false
			end
		end
	end
end

function input.keyboard.isPressed(action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if love.keyboard.isDown(input.list[i].key) then
				if input.keyboard.hasBeenPressed == false then
					input.keyboard.hasBeenPressed = true
					return true
				end
			else
				input.keyboard.hasBeenPressed = false
				return false
			end
		end
	end
end

-- Mouse --

function input.mouse.isDown(action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if love.mouse.isDown(input.list[i].key) then
				return true
			else
				return false
			end
		end
	end
end

function input.mouse.isPressed(action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if love.mouse.isDown(input.list[i].key) then
				if input.mouse.hasBeenPressed == false then
					input.mouse.hasBeenPressed = true
					return true
				end
			else
				input.mouse.hasBeenPressed = false
				return false
			end
		end
	end
end

return input