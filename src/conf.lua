io.stdout:setvbuf("no") -- Prints to SublimeText's console

function love.conf(c)

	c.title = "VideahEngine"
	c.author = "Ruairidh 'VideahGams' Carmichael"
	c.identity = "VideahEngine"

	c.window.width = 1280
	c.window.height = 720
	c.window.resizable = true

end