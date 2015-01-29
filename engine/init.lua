engine = {}
engine.path = ...

local requirepath = engine.path .. '.'

engine.debug 		= require(requirepath .. 'libs.solar')
engine.splash 		= require(requirepath .. 'libs.splashy')
engine.ui 			= require(requirepath .. 'libs.LoveFrames')
engine.map 			= require(requirepath .. 'libs.STI')
engine.lightworld 	= require(requirepath .. 'libs.lightworld')

engine.global 		= require(requirepath .. 'modules.global')
engine.menu			= require(requirepath .. 'modules.menu')
engine.state		= require(requirepath .. 'modules.state')

function engine.load()

	print("Loaded VideahEngine " .. engine.global.version)

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