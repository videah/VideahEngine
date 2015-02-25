local maphandler = require(engine.path .. 'libs.STI')
local map = {}

map.currentmap = nil
map.currentmapname = nil

function map.loadmap(mapname)
	if pcall(function() map.currentmap = maphandler.new(game.path .. "maps/" .. mapname) end) then
		map.currentmapname = mapname
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
		map.currentmap:draw()
	end

end

return map