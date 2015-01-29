panel = {}
panel.namelist = {}
panel.functionlist = {}

function panel.load()

	panel.x = 15
	panel.y = 15
	panel.width = 250
	panel.height = 34
	panel.location = "upper-right"

	panel:addVariable("global.fps", function() return global.fps end)
	panel:addVariable("player.x", function() return math.floor(player.sx) end)
	panel:addVariable("player.y", function() return math.floor(player.sy) end)
	panel:addVariable("player.health", function() return player.health end)
	panel:addVariable("player.speed", function() return player.currentSpeed end)
	panel:addVariable("state", function() return state.currentState end)
	panel:addVariable("map", function() return map.currentMap end)
	panel:addVariable("currentWep", function() return player.currentWeapon end)
	panel:addVariable("Bullets in Memory", function() return #bullet.list end)
	panel:addVariable("ShouldClearBulletlist", function() return tostring(bullet.shouldClear) end)

end

function panel.draw()

	if global.debug == false then return end

	love.graphics.setColor(0,0,0,155)
	love.graphics.rectangle( "fill", panel.x, panel.y, panel.width, panel.height + ((#panel.namelist - 1.3) * 20) )
	love.graphics.setColor(255,255,255,255)

	love.graphics.setFont(font.debug)

	for i=0, #panel.namelist - 1 do

		love.graphics.print(panel.namelist[i + 1] .. ": " .. panel.functionlist[i + 1](), panel.x + 4, (panel.y + 4) + (20 * i)) 

	end

	panel.calculateLocation()

end

function panel:addVariable(name, variable)

	if type(variable) == 'function' then

		table.insert(panel.namelist, name)

		table.insert(panel.functionlist, variable)

		util.dprint("Added a variable to the debug panel.")
	else

		util.dprint("Could not add variable to debug panel (object isn't a function)")

	end

end

function panel.calculateLocation()

if panel.location == "upper-left" then
		panel.x = 15
		panel.y = 15
	elseif panel.location == "upper-right" then
		panel.x = (global.screenWidth - 15) - panel.width
		panel.y = 15
	elseif panel.location == "lower-left" then
		panel.x = 15
		panel.y = (global.screenHeight - 15) - panel.height
	elseif panel.location == "lower-right" then
		panel.x = (global.screenWidth - 15) - panel.width
		panel.y = (global.screenHeight - 15) - panel.height
	else
		util.dprint("Panel location improperly set. Defaulting to upper-left.")
		panel.location = "upper-left"
	end

end