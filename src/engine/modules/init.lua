local path =  ... .. '.'

function loadModule(name)

	local loadedMod = require(path .. name)

	if _G.debug then
		print(string.format("Loaded engine module '%s' ...", name))
	end

	return loadedMod

end