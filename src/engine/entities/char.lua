local Char = class("Character")

--[[---------------------------------------------------------
	- func: initialize(x, y, width, height, health)
	- desc: initializes the character
--]]---------------------------------------------------------
function Char:initialize(x, y, width, height, health, speed)

	self.x = x or 0
	self.y = y or 0

	self.width = width or 0
	self.height = height or 0

	self.health = health or 100

	self.speed = speed or 5

end

--[[---------------------------------------------------------
	- func: setPosition(x, y)
	- desc: sets the position of the character
--]]---------------------------------------------------------
function Char:setPosition(x, y)

	self.x, self.y = x, y

end

--[[---------------------------------------------------------
	- func: getPosition()
	- desc: gets the position of the character
--]]---------------------------------------------------------
function Char:getPosition()

	return self.x, self.y

end

--[[---------------------------------------------------------
	- func: setHealth(health)
	- desc: sets the health of the character
--]]---------------------------------------------------------
function Char:setHealth(health)

	self.health = health

end

--[[---------------------------------------------------------
	- func: getHealth()
	- desc: gets the health of the character
--]]---------------------------------------------------------
function Char:getHealth()

	return self.health

end

--[[---------------------------------------------------------
	- func: hurt(amount)
	- desc: hurts the character by a certain amount
--]]---------------------------------------------------------
function Char:hurt(amount)

	if amount ~= nil and amount < 0 then
		console.warning("Char:hurt() is for hurting the Character. Use Char:heal() instead.")
		return end
	self.health = self.health - (amount or 10)

end

--[[---------------------------------------------------------
	- func: kill()
	- desc: kills the character, setting the hp to 0
--]]---------------------------------------------------------
function Char:kill()

	self.health = 0

end

return Char