config = {}
config.bg = {}
config.sidepanel = {}
config.button = {}
config.title = {}

	config.title.text = "Untitled Game"
	config.title.image = "data/images/videahenginelogo.png"
	config.title.type = "image"
	config.title.imagescale = 0.75

	config.bg.image = "data/images/menubg.png"
	config.bg.color = {44, 62, 80}
	config.options = {"Start", "Options", "Customize", "Quit"}

	config.type = "scrolling_tiled"
	config.scrolldirection = "left"
	config.scrollspeed = 50

	config.sidepanel.color = {25, 25, 25, 155}
	config.sidepanel.width = 200

	config.button.font = love.graphics.newFont(24)
	config.button.height = 100
	config.button.gap = 5

return config