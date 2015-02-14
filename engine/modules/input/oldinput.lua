input = {}
input.list = {}

input.keyboard = {}
input.keyboard.hasBeenPressed = false

input.mouse = {}
input.mouse.hasBeenPressed = false

input.gamepad = {}
input.gamepad.pads = love.joystick.getJoysticks()
input.gamepad.hasBeenPressed = false

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
				else
					return false
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

function input.mouse.isClicked(action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if love.mouse.isDown(input.list[i].key) then
				if input.mouse.hasBeenPressed == false then
					input.mouse.hasBeenPressed = true
					return true
				else
					input.mouse.hasBeenPressed = false
					return false
				end
			else
				return false
			end
		end
	end
end

function input.mouse.getPos()
	return global.cursorx, global.cursory
end

function input.mouse.setPos(x, y)
	love.mouse.setPosition(x, y)
end

-- Gamepad --

function input.gamepad.isDown(id, action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if input.gamepad.pads[id]:isGamepadDown(input.list[i].key) then
				return true
			else
				return false
			end
		end
	end
end

function input.gamepad.isPressed(id, action)

	for i=1, #input.list do
		if input.list[i].action == action then
			if input.gamepad.pads[id]:isGamepadDown(input.list[i].key) then
				if input.gamepad.hasBeenPressed == false then
					input.gamepad.hasBeenPressed = true
					return true
				else
					return false
				end
			else
				input.gamepad.hasBeenPressed = false
				return false
			end
		end
	end
end

function input.update(dt)

	if love.mouse.isDown("l", "m", "r", "x1", "x2") == "false" then
		input.mouse.isClicked = false
	end

end

return input