local Char = entity.require("char")
Player = class("Player", Char)

--[[---------------------------------------------------------
	- func: initialize(x, y, width, height, health)
	- desc: initializes the player as a char subclass
--]]---------------------------------------------------------
function Player:initialize(x, y, width, height, health, speed)

	Char.initialize(self, x, y, width, height, health, speed)

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the player
--]]---------------------------------------------------------
function Player:draw()

	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: updates the player
--]]---------------------------------------------------------
function Player:update(dt)

	if input.keyboard.isDown("player_up") then
		self.y = self.y - self.speed * dt
	end

	if input.keyboard.isDown("player_down") then
		self.y = self.y + self.speed * dt
	end

	if input.keyboard.isDown("player_left") then
		self.x = self.x - self.speed * dt
	end

	if input.keyboard.isDown("player_right") then
		self.x = self.x + self.speed * dt
	end

end

return Player