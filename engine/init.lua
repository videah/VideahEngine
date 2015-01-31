engine = {}
engine.path = ... .. '.'

engine.debug 		= require(engine.path .. 'libs.solar')
engine.splash 		= require(engine.path .. 'libs.splashy')
engine.ui 			= require(engine.path .. 'libs.LoveFrames')
engine.map 			= require(engine.path .. 'libs.STI')
engine.lightworld 	= require(engine.path .. 'libs.lightworld')

engine.global 		= require(engine.path .. 'modules.global')
engine.menu			= require(engine.path .. 'modules.menu')
engine.state		= require(engine.path .. 'modules.state')

function engine.load()

	print("Loaded VideahEngine " .. engine.global.version)

end

function engine.draw()

	if engine.state:isCurrentState("splash") then
		engine.splash.draw()
	end

	engine.debug.draw()

	engine.global.fps = love.timer.getFPS()

	engine.global.cursorx = love.mouse.getX()
	engine.global.cursory = love.mouse.getY()

end

function engine.update(dt)

	if engine.state:isCurrentState("splash") then
		engine.splash.update(dt)
	end

end

return engine