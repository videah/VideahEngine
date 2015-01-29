input = {}
input.keylist = {}
input.actionlist = {}
input.currentmb = ""

function input.load()

	-- If there isn't a controls config file
	-- Then create it.

	if love.filesystem.exists("cfg/controls.ini") == false then
		local defaultSettings = 
		{
			controls = 
			{
				forward = 'w',
				backward = 's',
				left = 'a',
				right = 'd',
				sprint = 'lshift',
				nextwep = 'wu',
				prevwep = 'wd',
			},
		};

		LIP.save("cfg/controls.ini", defaultSettings)
	end

	-- Load the controls config.

	local loadedSettings = LIP.load('cfg/controls.ini');

	-- Bind actions to keys from the config.

	--Player Movement
	input:bind(loadedSettings.controls.forward, "player.forward")
	input:bind(loadedSettings.controls.backward, "player.backward")
	input:bind(loadedSettings.controls.left, "player.left")
	input:bind(loadedSettings.controls.right, "player.right")

	input:bind(loadedSettings.controls.sprint, "player.sprint")

	input:bind(loadedSettings.controls.nextwep, "player.nextwep")
	input:bind(loadedSettings.controls.prevwep, "player.prevwep")

	input:bind(loadedSettings.controls.primaryfire, "player.primaryfire")


end

-- Function to bind actions to keys

function input:bind(key, action)

	--TODO: Rebinding is currently broken, needs fixing.

	for i=0, #input.actionlist do
		if action == input.actionlist[i] then
			util.dprint("Replacing bind...")
			self.keylist[i] = key
			self.actionlist[i] = action
		elseif action ~= input.actionlist[i] and i == #input.actionlist then
			util.dprint("Binding " .. "'" .. action .. "'" .. " to " .. "'" .. key .. "'")
			table.insert(input.keylist, key)
			table.insert(input.actionlist, action)
		end
	end

end

-- Check if the key that's binded to an action is down.

function input.isDown(action)

	for i=0, #input.actionlist do
		if input.actionlist[i] == action then
			if love.keyboard.isDown(input.keylist[i]) then
				return true
			else
				return false
			end
		end
	end
end

-- Check if the mouse key that's binded to an action is down.

function input.mouseIsDown(action)

	for i=0, #input.actionlist do
		if input.actionlist[i] == action then
			if love.mouse.isDown(input.keylist[i]) then
				return true
			else
				return false
			end
		end
	end
end

-- Check if the mouse key that's binded to an action was pressed.

function input.mousePressed(action)

	for i=0, #input.actionlist do
		if input.actionlist[i] == action then
			if input.currentmb == input.keylist[i] then
				return true
			else
				return false
			end
		end
	end
end

-- Get the last mouse button pressed.
-- Then set the current mouse button to it.

function input.mousepressed( x, y, button)

	input.currentmb = button

end

-- Reset the current mouse button.

function input.update(dt)

	input.currentmb = ""

end