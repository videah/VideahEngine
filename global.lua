---------------------------------------------------------------------------------------------------
-- Global variables
global = {}

global.screenWidth = love.graphics.getWidth()
global.screenHeight = love.graphics.getHeight()

global.centerWidth = (global.screenWidth / 2) / camera.scale
global.centerHeight = (global.screenHeight / 2) / camera.scale

global.version = "0.0.4"

global.state = "game"


---------------------------------------------------------------------------------------------------
-- Global functions
function global:getFPS()
	return global.fps
end

function global.update(dt)

	global.mouseX, global.mouseY = love.mouse.getPosition()

	global.centerWidth = (global.screenWidth / 2) / camera.scale
	global.centerHeight = (global.screenHeight / 2) / camera.scale

end