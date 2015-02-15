local script = {}
local scriptpath = 'game/scripts/'

function script.run(file)

	dofile(scriptpath .. file .. ".lua")

end

function script.require(filepath)

	require(scriptpath .. filepath)

end

return script