io.stdout:setvbuf("no") -- Prints to SublimeText's console

function love.conf(c)

	c.title = "VideahEngine"
	c.author = "Ruairidh 'VideahGams' Carmichael"
	c.identity = "VideahEngine"

	c.args = {}
	for _, v in ipairs( arg ) do
		c.args[v] = true
	end

	if c.args["--dedicated"] then
		c.modules.keyboard = false
		c.modules.mouse = false
		c.modules.graphics = false
		c.modules.font = false
		c.modules.window = false
	end

end

local debug, print = debug, print

local function error_printer(msg, layer)
	local filename = "crash.log"
	local file     = ""
	local time     = os.date("%Y-%m-%d %H:%M:%S", os.time())
	local err      = debug.traceback(
		"Error: " .. tostring(msg), 1+(layer or 1)
	):gsub("\n[^\n]+$", "")

	if love.filesystem.isFile(filename) then
		file = love.filesystem.read(filename)
	end

	if file == "" then
		file = [[
VideahEngine Crash Log

Please report this to ruairidhcarmichael@live.co.uk

]]
	else
		file = file .. "\n\n"
	end

	file = file .. string.format([[
=========================
== %s ==
=========================
%s]], time, err)

	love.filesystem.write(filename, file)
	print(err)
end

function love.errhand(msg)

	msg = tostring(msg)

	error_printer(msg, 2)

	if not love.window or not love.graphics or not love.event then
		return
	end

	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, flags.width, flags.height)
		if not success or not status then
			return
		end
	end

	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local head = love.graphics.setNewFont("engine/assets/fonts/Varela-Regular.otf", math.floor(love.window.toPixels(22)))
	local font = love.graphics.setNewFont("engine/assets/fonts/Varela-Regular.otf", math.floor(love.window.toPixels(14)))

	love.graphics.setBackgroundColor(30, 31, 32)
	love.graphics.setColor(255, 255, 255, 255)

	-- Don't show conf.lua in the traceback.
	local trace = debug.traceback("", 2)

	love.graphics.clear(love.graphics.getBackgroundColor())
	love.graphics.origin()

	local err = {}

	table.insert(err, msg.."\n")

	for l in string.gmatch(trace, "(.-)\n") do
		if not string.match(l, "boot.lua") then
			l = string.gsub(l, "stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local c = string.format("Crash log saved to : %s\n\nPress F11 to open the folder.", love.filesystem.getSaveDirectory() .. "/crash.log")
	local h = "Oops, something went wrong."
	local p = table.concat(err, "\n")

	p = string.gsub(p, "\t", "")
	p = string.gsub(p, "%[string \"(.-)\"%]", "%1")

	local function draw()
		local pos = love.window.toPixels(70)
		love.graphics.clear(love.graphics.getBackgroundColor())
		love.graphics.setColor(212, 30, 29)
		love.graphics.setFont(head)
		love.graphics.printf(h, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.setFont(font)
		love.graphics.setColor(255, 255, 255)
		love.graphics.printf(c, pos, pos + love.window.toPixels(40), love.graphics.getWidth() - pos)
		love.graphics.printf(p, pos, pos + love.window.toPixels(120), love.graphics.getWidth() - pos)
		love.graphics.present()
	end

	local reset = false

	while true do
		love.event.pump()

		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return
			elseif e == "keypressed" and a == "f11" then
				love.system.openURL("file://" .. love.filesystem.getSaveDirectory())
			elseif e == "keypressed" and a == "f5" then
				reset = true
				break
			elseif e == "keypressed" and a == "escape" and (love.window.getFullscreen()) then
				return
			elseif e == "keypressed" and a == "escape" then --or e == "mousereleased" then
				local name = love.window.getTitle()
				if #name == 0 then name = "Game" end
				local buttons = {"OK", "Cancel"}
				local pressed = love.window.showMessageBox("Quit?", "Quit "..name.."?", buttons)
				if pressed == 1 then
					return
				end
			end
		end

		draw()

		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end