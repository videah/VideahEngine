hud = {}

print("Loaded HUD system ...")

function hud.load()

end

function hud.draw()

	love.graphics.setColor(25,25,25,155)
	love.graphics.rectangle("fill", 15, 15, 240, 60 )

	--Health Bar [TEMPORARY]
	love.graphics.setColor(255,0,0,255)
	love.graphics.rectangle("fill", 15, 15, player.health * 2.4, 60 )


	-- Fallback
	love.graphics.setColor(255,255,255,255)

end

function hud.update(dt)

end