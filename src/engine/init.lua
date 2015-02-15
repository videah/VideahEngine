engine = {}
engine.path = ... .. '.'

engine.class		= require(engine.path .. 'util.middleclass')

engine.graphics		= require(engine.path .. 'modules.graphics')
engine.global 		= require(engine.path .. 'modules.global')
engine.input		= require(engine.path .. 'modules.input')
engine.menu			= require(engine.path .. 'modules.menu')
engine.state		= require(engine.path .. 'modules.state')
engine.network		= require(engine.path .. 'modules.network')
engine.script		= require(engine.path .. 'modules.script')

engine.panel 		= require(engine.path .. 'libs.solar')
engine.splash 		= require(engine.path .. 'libs.splashy')
engine.ui 			= require(engine.path .. 'libs.LoveFrames')
engine.map 			= require(engine.path .. 'libs.STI')
engine.lightworld 	= require(engine.path .. 'libs.lightworld')

function engine.load()

	math.randomseed(os.time())

	print("Loaded VideahEngine " .. _g.version)

end

function engine.draw()

	if engine.state:isCurrentState("splash") then
		engine.splash.draw()
	end

	engine.ui.draw()

	-- Debug --
	if _g.debug then
		engine.panel.draw()
	end

	_g.fps = love.timer.getFPS()
	_g.cursorx = love.mouse.getX()
	_g.cursory = love.mouse.getY()

end

function engine.update(dt)

	engine.input.update(dt)

	if engine.state:isCurrentState("splash") then
		engine.splash.update(dt)
	end

	engine.ui.update(dt)

	engine.network.update(dt)

end

function engine.resize(w, h)

	_g.screenWidth = w
	_g.screenHeight = h

end

function engine.mousepressed(x, y, button)

	engine.ui.mousepressed(x, y, button)
	engine.input.mousepressed(x, y, button)

end
 
function engine.mousereleased(x, y, button)

	engine.ui.mousereleased(x, y, button)

end
 
function engine.keypressed(key, unicode)

	engine.ui.keypressed(key, unicode)

end
 
function engine.keyreleased(key)

	engine.ui.keyreleased(key)

end

function engine.textinput(text)

	engine.ui.textinput(text)

end

return engine