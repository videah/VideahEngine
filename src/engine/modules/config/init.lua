local config = {}
local confighandler = require(engine.path .. 'utils.LIP')

function config.load(file)

	local data = confighandler.load(file)
	return data
end

function config.save(name, tbl)

	confighandler.save(name, tbl)

end

return config