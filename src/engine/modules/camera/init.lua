local Camera = engine.class("Camera")

function Camera:initialize(x, y, scale, strict)

	self.x = x or 0
	self.y = y or 0

	if type(scale) == "table" then
		self.scale = {scale[1], scale[2]}
	else
		self.scale = scale or 1
	end

	self.shakeX = 0
	self.shakeY = 0

	self.angle = 0

	self.strict = self.strict or false

	self.shaking = false
	self.shakeIntensity = 0
	self.shakeDuration = nil

end

function Camera:update(dt)

	-- TODO: Fix camera shake.

	if self.shaking then

		local shakeoffsetx = math.random(-self.shakeIntensity, self.shakeIntensity)
		local shakeoffsety = math.random(-self.shakeIntensity, self.shakeIntensity)

		self.shakeX, self.shakeY = self:getPosition()

		self.shakeX = self.shakeX + shakeoffsetx
		self.shakeY = self.shakeY + shakeoffsety

		if self.shakeDuration ~= nil then
			self.shakeIntensity = self.shakeIntensity - (1 / (self.shakeDuration * 10))
			if self.shakeIntensity <= 0 then
				self.shakeDuration = nil
				self.shaking = false
			end
		end
	else
		self.shakeX, self.shakeY = 0, 0
	end
end


function Camera:set()

	local finalx = -self.x + -self.shakeX
	local finaly = -self.y + -self.shakeY

	if self.strict then
		finalx = math.floor(finalx)
		finaly = math.floor(finaly)
	end

	if type(self.scale) == "table" then
		local sx, sy = self.scale[1], self.scale[2]
	else
		local sx, sy = self.scale
	end

	love.graphics.push()
	love.graphics.scale(sx, sy)
	love.graphics.translate(finalx, finaly)
	love.graphics.rotate(-self.angle)

end

function Camera:unset()

	love.graphics.pop()

end

function Camera:setPosition(x, y)
	self.x, self.y = x, y
end

function Camera:shake(intesity, duration)
	self.shaking = true
	self.shakeIntensity = intesity or 1
	self.shakeDuration = duration or nil
end

function Camera:move(direction, amount)

	amount = amount or 5

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

function Camera:getMousePosition()
	return math.floor(_G.cursorx + self.x), math.floor(_G.cursory + self.y)
end

function Camera:getMouseX()
	return math.floor(_G.cursorx + self.x)
end

function Camera:getMouseY()
	return math.floor(_G.cursory + self.y)
end

function Camera:getPosition()
	local finalx = -self.x + -self.shakeX
	local finaly = -self.y + -self.shakeY
	if self.strict then
		finalx = math.floor(finalx)
		finaly = math.floor(finaly)
	end
	return finalx, finaly
end

function Camera:getX()
	local finalx = -self.x + -self.shakeX
	if self.strict then
		finalx = math.floor(finalx)
	end
	return finalx
end
function Camera:getY()
	local finaly = -self.y + -self.shakeY
	if self.strict then
		finaly = math.floor(finaly)
	end
	return finaly
end

function Camera:getScale()
	return self.scale
end

return Camera