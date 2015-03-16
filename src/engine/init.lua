engine = {}
engine.path = ... .. '.'

function engine.load(args)

	engine.class		= require(engine.path .. 'util.middleclass')

	engine.graphics		= require(engine.path .. 'modules.graphics')
	engine.camera		= require(engine.path .. 'modules.camera')
	engine.global 		= require(engine.path .. 'modules.global')
	engine.input		= require(engine.path .. 'modules.input')
	engine.lighting		= require(engine.path .. 'modules.lighting')
	engine.map 			= require(engine.path .. 'modules.map')
	engine.menu			= require(engine.path .. 'modules.menu')
	engine.state		= require(engine.path .. 'modules.state')
	engine.network		= require(engine.path .. 'modules.network')
	engine.chat			= require(engine.path .. 'modules.chat')
	engine.script		= require(engine.path .. 'modules.script')

	engine.panel 		= require(engine.path .. 'libs.solar')
	engine.splash 		= require(engine.path .. 'libs.splashy')
	engine.ui 			= require(engine.path .. 'libs.LoveFrames')

	if CLIENT then
		engine.console		= require(engine.path .. 'libs.loveconsole')
	else
		engine.console		= require(engine.path .. 'libs.loveserverconsole')
	end

	require(engine.path .. 'cfg.cmds') -- Load Console Commands

	math.randomseed(os.time())

	for i=1, 3 do
		math.random() -- Warm up random number generator
	end

	print("Loaded VideahEngine " .. _G.version)

end

function engine.draw()

	if engine.state:isCurrentState("splash") then
		engine.splash.draw()
	end

	engine.ui.draw()

	-- Debug --
	if _G.debugmode then
		engine.panel.draw()
	end

	engine.console.draw()

	_G.fps = love.timer.getFPS()
	_G.cursorx = love.mouse.getX()
	_G.cursory = love.mouse.getY()

end

function engine.update(dt)

	if engine.state:isCurrentState("splash") then
		engine.splash.update(dt)
	end

	engine.ui.update(dt)

	engine.network.update(dt)

end

function engine.resize(w, h)

	_G.screenWidth = w
	_G.screenHeight = h

	engine.map.resize(w, h)
	engine.console.resize(w, h)

end

function engine.mousepressed(x, y, button)

	engine.ui.mousepressed(x, y, button)

end
 
function engine.mousereleased(x, y, button)

	engine.ui.mousereleased(x, y, button)

end
 
function engine.keypressed(key, unicode)

	engine.ui.keypressed(key, unicode)

	engine.console.keypressed(key, unicode)

end
 
function engine.keyreleased(key)

	engine.ui.keyreleased(key)

end

function engine.textinput(text)

	engine.ui.textinput(text)

	engine.console.textinput(text)

end

return engine