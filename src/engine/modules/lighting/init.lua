local lighting = {}
local lightworld = require(... .. ".lightworld")

function lighting.newWorld(...)
	return lightworld({...})
end

return lighting