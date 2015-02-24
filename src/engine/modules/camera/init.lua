camera = {}

camera.x = 0
camera.y = 0
camera.angle = 0

camera.shaking = false
camera.shakeintensity = 10
camera.shakeduration = 0
camera.shakeX = 0
camera.shakeY = 0

function camera:set()

	local finalx = -self.x + -self.shakeX
	local finaly = -self.y + -self.shakeY

	love.graphics.push()
	love.graphics.scale(self.scale)
	love.graphics.translate(finalx, finaly)
	love.graphics.rotate(-self.angle)

end

function camera:unset()

	love.graphics.pop()

end

function camera:setPosition(x, y)

	self.x, self.y = x, y

end

function camera:getPosition()
	return self.x, self.y
end

function camera:getX()
	return self.x
end

function camera:getY()
	return self.y
end

function camera:shake(intesity, duration)

	self.shaking = true

end

function camera.update(dt)

	if camera.shaking then

		local shakeoffsetx = math.floor(math.random(-camera.shakeintensity, camera.shakeintensity))
		local shakeoffsety = math.floor(math.random(-camera.shakeintensity, camera.shakeintensity))

		camera.shakeX, camera.shakeY = camera:getPosition()

		camera.shakeX = camera.shakeX + shakeoffsetx
		camera.shakeY = camera.shakeY + shakeoffsety

	end

end

return camera