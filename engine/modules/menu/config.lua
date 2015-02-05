config = {}
config.bg = {}
config.sidepanel = {}
config.button = {}

	config.title = "Untitled Game"
	config.titleimage = ""
	config.titletype = "text"

	config.bg.image = "data/images/menubg.png"
	config.bg.color = {44, 62, 80}
	config.options = {"Start", "Options", "Customize", "Quit"}

	config.type = "scrolling_tiled"
	config.scrolldirection = "left"
	config.scrollspeed = 50

	config.sidepanel.color = {25, 25, 25, 155}
	config.sidepanel.width = 200

	config.button.font = love.graphics.newFont(16)
	config.button.height = 100
	config.button.gap = 5

return config