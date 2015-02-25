local camera = {}

camera.x = 0
camera.y = 0
camera.angle = 0

camera.strict = true

camera.shakeX = 0
camera.shakeY = 0
camera.shaking = false
camera.shakeIntensity = 10
camera.shakeDuration = nil

function camera:set()

	local finalx = -self.x + -self.shakeX
	local finaly = -self.y + -self.shakeY

	if self.strict then
		finalx = math.floor(finalx)
		finaly = math.floor(finaly)
	end

	love.graphics.push()
	love.graphics.scale(self.scale)
	love.graphics.translate(finalx, finaly)
	love.graphics.rotate(-self.angle)

end

function camera:unset()

	love.graphics.pop()

end

-- Positioning --

function camera:setPosition(x, y)

	self.x, self.y = x, y

end

function camera:move(direction, amount)

	local dir = string.lower(direction)

	if dir == "up" then
		self.y = self.y - amount
	elseif dir == "down" then
		self.y = self.y + amount
	elseif dir == "left" then
		self.x = self.x - amount
	elseif dir == "right" then
		self.x = self.x + amount
	end

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

-- Camera Shake --

function camera:shake(intesity, duration)

	self.shaking = true
	self.shakeIntensity = intesity or 10
	self.shakeDuration = duration or nil

end

function camera.update(dt)

	if camera.shaking then

		local shakeoffsetx = math.random(-camera.shakeIntensity, camera.shakeIntensity)
		local shakeoffsety = math.random(-camera.shakeIntensity, camera.shakeIntensity)

		camera.shakeX, camera.shakeY = camera:getPosition()

		camera.shakeX = camera.shakeX + shakeoffsetx
		camera.shakeY = camera.shakeY + shakeoffsety

		if camera.shakeDuration ~= nil then
			camera.shakeIntensity = camera.shakeIntensity - (1 / (camera.shakeDuration * 10))

			if camera.shakeIntensity <= 0 then
				camera.shakeDuration = nil
				camera.shaking = false
			end
		end
	else

		camera.shakeX, camera.shakeY = 0, 0

	end

end

return camera