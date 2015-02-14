game = {}
game.path = ... .. '/'

function game.load()

	-- Set default state --
	engine.state.setState("splash")

	-- Splash Screen --
	engine.splash.addSplash(love.graphics.newImage("game/data/images/splashes/love.png"))
	engine.splash.onComplete(function() engine.state.setState("menu") end)

	-- Debug Vars --
	-- engine.debug.addVar("FPS", function() return global.fps end)
	-- engine.debug.addVar("global.version", function() return engine.global.version end)
	-- engine.debug.addVar("state.currentState", function() return engine.state.currentState end)
	-- engine.debug.addVar("global.mousex", function() return engine.global.cursorx end)
	-- engine.debug.addVar("global.mousey", function() return engine.global.cursory end)
	-- engine.debug.addBar("Test Bardwwwadw", function() return engine.global.fps end, nil, nil, 50, {231, 76, 60})
	-- engine.debug.addBar("Test Bar", function() return engine.global.fps end, nil, nil, 500, {46, 204, 113})
	-- engine.debug.addBar("Ā ā Ă ă Ą ą Ć ć Ĉ", function() return engine.global.fps end, 60, 300, 50, {52, 152, 219})
	-- engine.debug.addWheel("Test Wheel", function() return engine.global.fps end)
	-- engine.debug.addWheel("Test Wheel", function() return engine.global.fps end)
	-- engine.debug.addWheel("Test Wheel", function() return engine.global.fps end)
	-- engine.debug.addWheel("Test Wheel", function() return engine.global.fps end)
	-- engine.debug.addWheel("Test Wheel", function() return engine.global.fps end)

	-- testbool = true

	-- engine.debug.addVar("FPS", function() return global.fps end)
	-- engine.debug.addVar("Is solar awesome?", function() return testbool end)
	-- engine.debug.addVar("Are you sure?", function() return "Of course!" end)
	-- engine.debug.addDivider()
	-- engine.debug.addBar("solar's Awesomeness", function() return 100 end, nil, nil, nil, {231, 76, 60})
	-- engine.debug.addBar("solar's Awesomeness / 2", function() return 50 end, nil, nil, nil, {46, 204, 113})
	-- engine.debug.addBar("solar's Awesomeness / 5", function() return 20 end, nil, nil, nil, {52, 152, 219})
	-- engine.debug.addDivider()

	engine.debug.addVar("Mouse is clicked", function() return input.mouse.clickedbutton end)

	--engine.input.mouse.bind("l", "click")

	-- Menu Buttons --
	engine.menu.addButton("Start", 0, 0, function() engine.state.setState("game") end)
	engine.menu.addButton("Quit", 0, 0, function() love.event.quit() end)

end

function game.draw()

	if engine.state:isCurrentState("menu") then	
		engine.menu.draw()
	end

end

function game.update(dt)

	if engine.state:isCurrentState("menu") then
		engine.menu.update(dt)
	end

end

return game