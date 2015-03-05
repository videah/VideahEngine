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

	engine.console.print("Started to load map '" .. mapname .. "'...", {r = 241, g = 196, b = 15, a = 255})

	if pcall(function() map.currentmap = maphandler.new(game.path .. "maps/" .. mapname) end) then

		map.currentmapname = mapname
		map.lightworld = engine.lighting.newWorld({ambient = {55,55,55}})
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
