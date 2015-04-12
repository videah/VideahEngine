io.stdout:setvbuf("no") -- Prints to SublimeText's console

function love.conf(c)

	c.title = "VideahEngine"
	c.author = "Ruairidh 'VideahGams' Carmichael"
	c.identity = "VideahEngine"

	c.window.width = 1920
	c.window.height = 1080
	c.window.resizable = false
	c.window.borderless = true
	c.window.icon = "engine/data/images/icon.png"

end