engine = {}
engine.path = ... .. '.'

function engine.load(args)

	engine.class		= require(engine.path .. 'util.middleclass')

	engine.config		= require(engine.path .. 'modules.config')
	engine.graphics		= require(engine.path .. 'modules.graphics')
	engine.camera		= require(engine.path .. 'modules.camera')
	engine.global 		= require(engine.path .. 'modules.global')
	engine.input		= require(engine.path .. 'modules.input')
	engine.lighting		= require(engine.path .. 'modules.lighting')
	engine.map 			= require(engine.path .. 'modules.map')
	engine.entity		= require(engine.path .. 'modules.entity')
	engine.menu			= require(engine.path .. 'modules.menu')
	engine.state		= require(engine.path .. 'modules.state')
	engine.network		= require(engine.path .. 'modules.network')
	engine.chat			= require(engine.path .. 'modules.chat')
	engine.script		= require(engine.path .. 'modules.script')

	engine.panel 		= require(engine.path .. 'libs.solar')
	engine.splash 		= require(engine.path .. 'libs.splashy')
	engine.ui 			= require(engine.path .. 'libs.Thranduil.UI')

	if CLIENT then
		engine.console		= require(engine.path .. 'libs.loveconsole')
	else
		engine.console		= require(engine.path .. 'libs.loveserverconsole')
	end

	engine.webconsole = require(engine.path .. 'modules.webconsole')

	require(engine.path .. 'cfg.cmds') -- Load Console Commands

	math.randomseed(os.time())

	for i=1, 3 do
		math.random() -- Warm up random number generator
	end

	engine.ui.registerEvents()

	print("Loaded VideahEngine " .. _G.version)

end

function engine.draw()

	if engine.state:isCurrentState("splash") then
		engine.splash.draw()
	end

	-- Debug --
	if _G.debugmode then
		-- engine.panel.draw()
	end

	engine.console.draw()

	_G.fps = love.timer.getFPS()
	_G.cursorx = love.mouse.getX()
	_G.cursory = love.mouse.getY()

	love.graphics.setColor(255, 255, 255, 255)

end

function engine.update(dt)

	if engine.state:isCurrentState("splash") then
		engine.splash.update(dt)
	end

	engine.network.update(dt)

	engine.webconsole.update(dt)

end

function engine.resize(w, h)

	_G.screenWidth = w
	_G.screenHeight = h

	engine.map.resize(w, h)
	engine.console.resize(w, h)

end

function engine.mousepressed(x, y, button)



end
 
function engine.mousereleased(x, y, button)



end
 
function engine.keypressed(key, unicode)

	engine.console.keypressed(key, unicode)

	if engine.state:isCurrentState("splash") then

		if key == " " then
			engine.splash.skipSplash()
		end

	end

end
 
function engine.keyreleased(key)



end

function engine.textinput(text)

	engine.console.textinput(text)

end

return engine