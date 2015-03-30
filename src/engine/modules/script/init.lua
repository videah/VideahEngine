local script = {}
local scriptpath = 'game/scripts/'

function script.run(file)

	love.filesystem.load(scriptpath .. file .. ".lua")()

end

function script.require(filepath)

	return require(scriptpath .. filepath)

end

return script