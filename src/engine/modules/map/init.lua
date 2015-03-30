local maphandler = require(engine.path .. 'libs.STI')
local map = {}

map.currentmap = nil
map.currentmapname = nil
map.lightworld = engine.lighting.newWorld({ambient = {0, 0, 0}})
love.physics.setMeter(64)
map.physicsworld = love.physics.newWorld(0,0)
map.lightcollisions = nil
map.physicscollisions = nil

function map.loadmap(mapname)

	engine.console.print("Started to load map '" .. mapname .. "'...", {r = 52, g = 152, b = 219})

	if pcall(function() map.currentmap = maphandler.new(game.path .. "maps/" .. mapname) end) then

		if map.currentmap.properties.ambientRed == nil or map.currentmap.properties.ambientGreen == nil or map.currentmap.properties.ambientBlue == nil then

			engine.console.warning("No ambience settings found. Setting lighting to fullbright.")

		end

		local ambR = tonumber(map.currentmap.properties.ambientRed) or 255
		local ambG = tonumber(map.currentmap.properties.ambientGreen) or 255
		local ambB = tonumber(map.currentmap.properties.ambientBlue) or 255

		map.currentmapname = mapname
		map.lightworld = engine.lighting.newWorld()

		-- Ambience --

		map.lightworld.ambient[1] = ambR
		map.lightworld.ambient[2] = ambG
		map.lightworld.ambient[3] = ambB

		engine.console.print("Loaded map ambience...", {r = 52, g = 152, b = 219})

		map.physicscollisions = map.currentmap:initWorldCollision(map.physicsworld)
		map.lightcollisions = map.currentmap:initLightCollision(map.lightworld)
		engine.console.success("Loaded map '" .. mapname .. "'")

	else
		engine.console.error("Could not load map '" .. mapname .. "' (map file not found.)")
	end
end

function map.unload(mapname)

	if map.currentmap ~= nil then

		map.lightcollisions = nil
		engine.console.print("Unloaded light colliders...", {r = 241, g = 196, b = 15, a = 255})

		map.physicscollisions = nil
		engine.console.print("Unloaded physics colliders...", {r = 241, g = 196, b = 15, a = 255})

		map.currentmap = nil
		map.currentmapname = nil
		engine.console.success("Unloaded map '" .. mapname .. "'")
		
	end

end

function map.draw()

	if map.currentmap ~= nil then
		map.currentmap:setDrawRange(0, 0, _G.screenWidth, _G.screenHeight)
		map.currentmap:draw()
	end

end

function map.resize(w, h)

	if map.currentmap ~= nil then
		map.currentmap:resize(w, h)
	end

end

return map
