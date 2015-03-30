local Char = engine.script.require("char")
Player = engine.class("Player", Char)

--[[---------------------------------------------------------
	- func: initialize(x, y, width, height, health)
	- desc: initializes the player as a char subclass
--]]---------------------------------------------------------
function Player:initialize(x, y, width, height)

	Char.initialize(self, x, y, width, height)

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

	if engine.input.keyboard.isDown("player_up") then
		self.y = self.y - self.speed
	end

	if engine.input.keyboard.isDown("player_down") then
		self.y = self.y + self.speed
	end

	if engine.input.keyboard.isDown("player_left") then
		self.x = self.x - self.speed
	end

	if engine.input.keyboard.isDown("player_right") then
		self.x = self.x + self.speed
	end

end

return Player