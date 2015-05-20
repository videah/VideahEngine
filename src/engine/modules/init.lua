local path =  ... .. '.'
loadedmodules = {}

function loadModule(name)

	local loadedMod = require(path .. name)

	if _G.debug then
		print(string.format("Loaded engine module '%s' ...", name))
	end

	if loadedMod then
		loadedmodules[#loadedmodules + 1] = name
	end

	return loadedMod

end

function depend(name)

	for i=1, #loadedmodules do

		if loadedmodules[i] == name then

			return true

		end

	end

	error("The '" + name + "' module is required for certain loaded modules to work.")

end