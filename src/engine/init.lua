engine = {}
engine.path = ... .. '/'

function engine.load(args)

	require(engine.path .. 'modules')

	if CLIENT then
		console	= require(engine.path .. 'libs/loveconsole')
	else
		console	= require(engine.path .. 'libs/loveserverconsole')
	end

	webconsole = loadModule('webconsole')

	class		= require(engine.path .. 'util/middleclass')

	hook		= loadModule('hook')
	cfg 		= loadModule('config')
	graphics	= loadModule('graphics')
	camera		= loadModule('camera')
	global 		= loadModule('global')
	input		= loadModule('input')
	lighting	= loadModule('lighting')
	map 		= loadModule('map')
	entity		= loadModule('entity')
	menu		= loadModule('menu')
	state		= loadModule('state')
	network		= loadModule('network')
	chat		= loadModule('chat')
	script		= loadModule('script')

	panel 		= require(engine.path .. 'libs/solar')
	splash 		= require(engine.path .. 'libs/splashy')
	ui 			= require(engine.path .. 'libs/Thranduil.UI')

	require(engine.path .. 'cfg.cmds') -- Load Console Commands

	math.randomseed(os.time())

	for i=1, 3 do
		math.random() -- Warm up random number generator
	end

	ui.registerEvents()

	print("Loaded VideahEngine " .. _G.version)

end

function engine.draw()

	if state:isCurrentState("splash") then
		splash.draw()
	end

	-- Debug --
	if _G.debugmode then
		-- panel.draw()
	end

	console.draw()

	_G.fps = love.timer.getFPS()
	_G.cursorx = love.mouse.getX()
	_G.cursory = love.mouse.getY()

	love.graphics.setColor(255, 255, 255, 255)

end

function engine.update(dt)

	if state:isCurrentState("splash") then
		splash.update(dt)
	end

	network.update(dt)

	webconsole.update(dt)

end

function engine.resize(w, h)

	_G.screenWidth = w
	_G.screenHeight = h

	map.resize(w, h)
	console.resize(w, h)

end

function engine.mousepressed(x, y, button)



end
 
function engine.mousereleased(x, y, button)



end
 
function engine.keypressed(key, unicode)

	console.keypressed(key, unicode)

	if state:isCurrentState("splash") then

		if key == " " then
			splash.skipSplash()
		end

	end

end
 
function engine.keyreleased(key)



end

function engine.textinput(text)

	console.textinput(text)

end

return engine