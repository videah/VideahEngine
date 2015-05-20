local path = ... .. '.'
local entity = {}

function entity.create(name, ...)

	local arguments = {...}

	return require(engine.path .. 'entities/' .. name):new(unpack(arguments))

end

return entity