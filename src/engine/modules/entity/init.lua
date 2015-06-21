local path = ... .. '.'
local entity = {}

function entity.create(name, ...)

	local arguments = {...}
	local ent = require(game.path .. 'entities/' .. name):new(unpack(arguments))

	ent.type = name

	return ent

end

function entity.require(name)

	return require(game.path .. 'entities/' .. name)

end

return entity