engine = {}

local path = ... .. '.'

engine.debug 		= require(path .. 'libs.solar')
engine.splash 		= require(path .. 'libs.splashy')
engine.ui 			= require(path .. 'libs.LoveFrames')
engine.map 			= require(path .. 'libs.STI')
engine.lightworld 	= require(path .. 'libs.lightworld')

engine.global 		= require(path .. 'modules.global')

function engine.load()

	print("Loaded VideahEngine" .. engine.global.version)

end

function engine.draw()

	engine.splash.draw()
	engine.debug.draw()

end

function engine.update(dt)

	engine.splash.update(dt)

end

return engine