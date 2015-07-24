local config = {}
local confighandler = require(engine.path .. 'util.LIP')

function config.load(file)

	local data = confighandler.load(file .. ".cfg")
	return data
end

function config.save(name, tbl)

	confighandler.save(name .. ".cfg", tbl)

end

function config.exists(name)

	return love.filesystem.exists(name .. ".cfg")

end

function config.defaultCFG()

	local tbl = {

		graphics = {

			vsync = false,
			fullscreen = true,
			borderless = false,
			resolutionwidth = 800,
			resolutionheight = 600

		}

	}

	return tbl

end

function config.defaultServerCFG()


	local tbl = {

		settings = {

			name = "VideahEngine Server",
			map = "dev_01",
			maxplayers = 16,
			tickrate = 60

		}

	}

	return tbl

end

return config