lighting = {}
lighting.shouldDraw = false

print("Loaded lighting engine ...")

function lighting.load()

	lighting.world = LightWorld({
		ambient = {55,55,55},
	})
	
end

function lighting.update(dt)

	lighting.world:update(dt)

end
	
function lighting.draw()

end
