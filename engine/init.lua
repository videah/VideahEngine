engine = {}

local path = ... .. '.'

engine.debug 		= require(path .. 'libs.solar')
engine.splash 		= require(path .. 'libs.splashy')
engine.ui 			= require(path .. 'libs.LoveFrames')
engine.map 			= require(path .. 'libs.STI')
engine.lightworld 	= require(path .. 'libs.lightworld')

engine.global 		= require(path .. 'modules.global')
engine.menu			= require(path .. 'modules.menu')
engine.state		= require(path .. 'modules.state')

function engine.load()

	print("Loaded VideahEngine" .. engine.global.version)

end

function engine.draw()

	if engine.state:isCurrentState("splash") then
		engine.splash.draw()
	end

	engine.debug.draw()

end

function engine.update(dt)

	if engine.state:isCurrentState("splash") then
		engine.splash.update(dt)
	end

end

return engine