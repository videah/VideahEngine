-- Custom Commands --

if CLIENT then

	engine.console.addCommand("connect", function(args)
		if args then
			engine.network.client.connect(args[1], "18025")
		else
			-- Error is returned to the console. In case of console.execute, error is returned to the "out" variable.
			console.print("Missing required arguments")
		end
	end, "Connects to a server. - Arguments: [ip address]")

	engine.console.addCommand("say", function(args)
		if args then
			engine.network.client.say(table.concat(args, " "))
		else
			console.print("Missing required arguments")
		end
	end, "Send player message. Arguments: [message]")


	engine.console.addCommand("name", function(args)
		if args then
			game.playername = table.concat(args, " ")
			console.print("Set player name to: " .. game.playername)
		else
			console.print("Missing required arguments")
		end
	end, "Sets current username. Arguments: [name]")

end

if SERVER then

	engine.console.addCommand("say", function(args)
		if args then
			engine.network.server.say(table.concat(args, " "))
		else
			console.print("Missing required arguments")
		end
	end, "Send server message. Arguments: [message]")

end