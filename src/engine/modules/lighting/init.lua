local lighting = {}
local LightWorld = require(... .. ".lightworld")

function lighting.newWorld(...)
	return LightWorld(...)
end

return lighting