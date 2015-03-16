if CLIENT then

	-- Client Commands --

	engine.console.addCommand("connect", function(args)
		if args then
			engine.network.client.connect(args[1], "18025")
		else
			-- Error is returned to the console. In case of console.execute, error is returned to the "out" variable.
			engine.console.print("Missing required arguments")
		end
	end, "Connects to a server. Arguments: [ip address]")

	engine.console.addCommand("say", function(args)
		if args then
			engine.network.client.say(table.concat(args, " "))
		else
			engine.console.print("Missing required arguments")
		end
	end, "Send player message. Arguments: [message]")


	engine.console.addCommand("name", function(args)
		if args then
			game.playername = table.concat(args, " ")
			engine.console.print("Set player name to: " .. game.playername)
		else
			engine.console.print("Missing required arguments")
		end
	end, "Sets current username. Arguments: [name]")

	engine.console.addCommand("map", function(args)
		if args then
			engine.map.loadmap(args[1])
		else
			engine.console.print("Missing required arguments")
		end
	end, "Sets the current map. Arguments: [mapname]")

end

if SERVER then

	-- Server Commands --

	engine.console.addCommand("say", function(args)
		if args then
			engine.network.server.say(table.concat(args, " "))
		else
			engine.console.print("Missing required arguments")
		end
	end, "Send server message. Arguments: [message]")

	engine.console.addCommand("status", function(args)

		engine.network.server.status()
		
	end, "Displays server information. Arguments: None.")

	engine.console.addCommand("map", function(args)
		if args then
			engine.map.loadmap(args[1])
		else
			engine.console.print("Missing required arguments")
		end
	end, "Sets the current map. Arguments: [mapname]")

end

-- Shared Commands --

-- We wrap functions in a custom callback.
engine.console.addCommand("clear", function() console.clear() end, "Clears the entire console.")
engine.console.addCommand("quit", function() love.event.quit() end, "Attempts to close the application.")

-- Command callbacks can also receive a table of string arguments.
engine.console.addCommand("print", function(args)
	if args then
		engine.console.print(table.concat(args, " "))
	else
		-- Error is returned to the console. In case of console.execute, error is returned to the "out" variable.
		engine.console.print("Missing required arguments")
	end
end, "Prints trailing command arguments as a formatted string - Arguments: [string to print]")

-- Executes a lua command and prints it's return value to the console.
engine.console.addCommand("run", function(args)
	if args then
		local value = assert(loadstring(string.format("return %s", table.concat(args, " "))))()

		if value then
			engine.console.print(string.format("Returned %s", tostring(value)))
		else
			engine.console.print(string.format("Executing %s returned nil", table.concat(args, " ")))
		end
	else
		engine.console.print("Missing the argument lua code to execute")
	end
end, "Executes the supplied lua function - Arguments: [lua command to execute] - Example: 'engine.console.print(\"Do the fishstick!\")'")

-- Same as run with the difference of not returning a value and so avoiding errors while assigning new values to variables.
engine.console.addCommand("set", function(args)
	if args then
		assert(loadstring(string.format('%s', table.concat(args, " "))))()
		engine.console.print("Variable entry set")
	else
		engine.console.print("Missing the argument lua code to set")
	end
end, "Sets a supplied variable - Arguments: [lua assignment to execute] - Example: 'console.enabled = false'")

-- Amazing help command of doom. It helps people.
engine.console.addCommand("help", function(args)
	if not args then
		engine.console.print("Available commands are:")
		for k, v in pairs(engine.console.consoleCommands) do
			if v.description ~= "" then
				engine.console.print(string.format("%s - %s", k, v.description), {0, 255, 0})
			else
				engine.console.print(k, config.colors.success)
			end
		end
	else
		local name = table.concat(args, " ")
		if engine.console.consoleCommands[name] then
			if engine.console.consoleCommands[name].description then
				engine.console.print(string.format("%s - %s", name, engine.console.consoleCommands[name].description), {r = 0, g = 255, b = 0})
			else
				engine.console.print(string.format("The command with the name of '%s' does not have a description.", name))
			end
		else
			engine.console.print(string.format("The command with the name of '%s' was not found in the command table.", name))
		end
	end
end, "Outputs the names and descriptions of all available console commands or just a single one - Arguments: [command to fetch information on]")

-- Creates a new command entry that points to another command.
engine.console.addCommand("alias", function(args)
	if args then
		if args[1] and args[2] then
			if engine.console.consoleCommands[args[1]] then
				engine.console.addCommand(args[2], engine.console.consoleCommands[args[1]].callback, engine.console.consoleCommands[args[1]].description)
				engine.console.print(string.format("Successfully assigned the alias of '%s' to the command of '%s'.", args[2], args[1]))
			end
		else
			engine.console.print("Missing command arguments. Requires two.")
		end
	else
		engine.console.print("Missing command arguments. Requires two.")
	end
end, "Creates a new command list entry mimicking another command. Arguments: [command to alias] [alias name]")