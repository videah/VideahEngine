local maphandler = require(engine.path .. 'libs.STI')
local map = {}

map.currentmap = nil
map.currentmapname = nil
map.lightworld = nil

function map.loadmap(mapname)
	if pcall(function() map.currentmap = maphandler.new(game.path .. "maps/" .. mapname) end) then
		map.currentmapname = mapname
		map.lightworld = engine.lighting.newWorld({ambient = {55,55,55}})
		engine.console.success("Loaded map '" .. mapname .. "'")
	else
		engine.console.error("Could not load map '" .. mapname .. "' (map file not found.)")
	end
end

function map.unload()

	map.currentmap = nil
	map.currentmapname = nil
	engine.console.success("Unloaded current map.")

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