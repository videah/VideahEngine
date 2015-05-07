local util = {}

function util.getGlobalFromName(name)

	local global = _G
	for i in string.gfind(name, "[%w_]+") do
		global = global[i]
	end
	return global

end

return util