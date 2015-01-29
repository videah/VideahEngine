cursor = {}
cursor.crosshair = {}

function cursor.load()

	cursor.cursor = love.mouse.newCursor("data/images/cursor.png", 0, 0)
	cursor.image = love.graphics.newImage("data/images/crosshair.png")

end

-- Gross...

-- function cursor.crosshair.draw()

-- 	local startX = player.sx + 5
-- 	local startY = player.sy + 5
-- 	local mouseX = camera:getMouseX()
-- 	local mouseY = camera:getMouseY()

-- 	local angle = math.atan2((mouseY - startY), (mouseX - startX))

-- 	love.graphics.draw(cursor.image, global.mouseX - (cursor.image:getWidth() / 2), global.mouseY - (cursor.image:getHeight() / 2), angle, 1, 1, cursor.image:getWidth(), cursor.image:getHeight() / 2)

-- end