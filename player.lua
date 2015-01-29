player = {}

function player.load()

	player.name = "Player"
	player.image = "custom/template.png"
	player.baseSpeed = 1350
	player.currentSpeed = 0
	player.x = 0
	player.y = 0 -- TODO: Get starting position from map and set player position accordingly.
	player.size = 32
	player.isRunning = false
	player.weapons = {}
	player.currentWeapon = ""

	player.sy = 0
	player.sx = 0

	player.fx, player.fy = math.floor(player.sx), math.floor(player.sy)

	player.create()

	player.body:setLinearDamping(10)

	player:setTile(6,4) -- Temp positioning.

	--Ingame stats
	player.health = 100

	print("Player created!")

	player:giveWeapon("weapon_pistol")
	player:giveWeapon("weapon_machinegun")
	player:giveWeapon("weapon_lightspawner")

	player.currentWeapon = player.weapons[1] -- Temp

	player.InternalVariables()

end

function player.create()

	player.body		= love.physics.newBody(world, player.x, player.y, "dynamic")
	player.shape	= love.physics.newRectangleShape(player.size - 1, player.size - 1)
	player.fixture	= love.physics.newFixture(player.body, player.shape)
	player.fixture:setCategory( 2 )

end

function player.draw()

	love.graphics.setBlendMode("alpha")

	love.graphics.draw(player.image, math.floor(player.sx - 17), math.floor(player.sy - 17), 0, 0.135, 0.135)

	if state:isStateEnabled("multiplayer") then
		player:drawName(true)
	end

end

function player.update(dt)

	player.fx, player.fy = math.floor(player.x), math.floor(player.y)

	player.body:setAngle(0)

	player.setRunSpeed()

	player.controls(dt)

	player.sx, player.sy =  player.body:getPosition()

	-- Avoid funky side effects.
	if player.health < 0 then
		player.health = 0
	end

	player.updateWeaponList()

end

function player.controls(dt)

	if input.isDown("player.backward") then 
		player.y = player.y + (player.currentSpeed *dt) 
		player.body:applyForce(0, player.currentSpeed)
	end

	if input.isDown("player.forward") then 
		player.y = player.y - (player.currentSpeed *dt) 
		player.body:applyForce(0, -player.currentSpeed)
	end

	if input.isDown("player.right") then 
		player.x = player.x + (player.currentSpeed *dt) 
		player.body:applyForce(player.currentSpeed, 0)
	end

	if input.isDown("player.left") then 
		player.x = player.x - (player.currentSpeed *dt) 
		player.body:applyForce(-player.currentSpeed, 0)
	end

	if input.isDown("player.sprint") then
		player.isRunning = true
	else
		player.isRunning = false
	end

	-- Automatic firing
	if input.mouseIsDown("player.primaryfire") then

		if player:isCurrentWeapon("weapon_machinegun") then

			bullet.fire()
			camera:shake("hybrid", 4, true, 0.2)

		end

	end

	-- Semi-Automatic firing
	if input.mousePressed("player.primaryfire") then

		--Pistol
		if player:isCurrentWeapon("weapon_pistol") then
			bullet.fire()
			camera:shake("hybrid", 2, true, 0.2)
		end

		if player:isCurrentWeapon("weapon_lightspawner") then

			lighting.world:newLight(camera:getMouseX(), camera:getMouseY(), math.random(255), math.random(255), math.random(255), 250)

		end

	end

end

function player.setRunSpeed()

	if player.isRunning then
		player.currentSpeed = player.baseSpeed + 750
	else
		player.currentSpeed = player.baseSpeed
	end

end

function player:drawName(boolean)

	if boolean then

		love.graphics.setFont(font.playername)

		love.graphics.printf(player.name, player.sx + 16, player.sy - 32, 0, 'center')

		love.graphics.setFont(font.default)

	end

end

function player:getPosition()
	return player.sx, player.sy
end

function player:setPosition(x, y)
	player.body:setPosition(x, y)
end

	-- Sets the players position by tiles, rather than by pixels.
function player:setTile(x, y)
	player.body:setPosition((x * 32) - (self.size / 2), (y * 32) - (self.size / 2))
end

function player:hurt(hurtamount)
	if hurtamount ~= nil and hurtamount < 0 then
		util.dprint("player:hurt() is for hurting the player. Use player:heal() instead.")
		return end
	player.health = player.health - (hurtamount or 10)
end

function player:heal(healamount)
	player.health = player.health + (healamount or 10)
end

function player:kill()
	player.health = 0
end

function player:setHealth(healthamount)
	player.health = healthamount
end

function player:giveWeapon(name)

	local gotWeapon = weapon:getName(name)

	for i=0, #self.weapons do
		if self.weapons[i] == name then
			self.weapons[i] = gotWeapon
		elseif i == #self.weapons then
			table.insert(self.weapons, gotWeapon)
		end
	end
end

function player:getCurrentWeapon()

	return player.currentWeapon

end

function player:isCurrentWeapon(name)

	if name == player.currentWeapon then
		return true
	else
		return false
	end

end

function player.updateWeaponList(dt)

	if input.mousePressed("player.prevwep") then
		if player.weapons[#player.weapons] == player.currentWeapon then
			player.currentWeapon = player.weapons[1]
		else
			for i=1, #player.weapons do
				if player.currentWeapon == player.weapons[i] then
					player.currentWeapon = player.weapons[i + 1]
					break
				end
			end
		end
	end

	if input.mousePressed("player.nextwep") then
		if player.weapons[1] == player.currentWeapon then
			player.currentWeapon = player.weapons[#player.weapons]
		else
			for i=1, #player.weapons do
				if player.currentWeapon == player.weapons[i] then
					player.currentWeapon = player.weapons[i - 1]
					break
				end
			end
		end
	end
end


function player.InternalVariables()

	player.image = love.graphics.newImage(player.image)

end