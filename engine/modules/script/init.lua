script = {}
local scriptpath = 'game/scripts/'

function script.run(file)

	dofile(scriptpath .. file .. ".lua")

end

return script