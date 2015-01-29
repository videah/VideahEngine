weapon = {}
weapon.damagelist = {}
weapon.speedlist = {}
weapon.namelist = {}

bullet = {}
bullet.speed = 20
bullet.list = {}
bullet.variablelist = {}
bullet.shouldClear = false

print("Loaded weapon system ...")

--------Weapons--------

function weapon.load()

	-- Create some test weapons

	weapon:create(1, "weapon_pistol", 10, 250)
	weapon:create(2, "weapon_machinegun", 5, 450)
	weapon:create(3, "weapon_lightspawner", 0, 0)

	-- Start listening for bullet collisions

	world:setCallbacks( bullet.contact )

end

function weapon:create(id, name, damage, speed)

	-- Create a new weapon.
	-- Put all weapons stats in seperate lists.

	weapon.namelist[id] = name
	weapon.damagelist[id] = damage
	weapon.speedlist[id] = speed

	util.dprint("Created weapon. id = " .. id .. " name = " .. name)

end

-- Get the ID from a weapon name.

function weapon:getID(name)
	for i=1, #self.namelist do
		if self.namelist[i] == name then
			return i
		end
	end
end

-- Get the weapon name from a weapon name.
-- Sounds stupid, but is mostly to
-- confirm that the weapon exists.

function weapon:getName(name)
	for i=1, #self.namelist do
		if self.namelist[i] == name then
			return weapon.namelist[i]
		end
	end

end

-- Get the weapons damage from a weapon name.

function weapon:getDamage(name)
	for i=1, #self.namelist do
		if self.namelist[i] == name then
			return weapon.damagelist[i]
		end
	end
end

-- Get the weapons speed from a weapon name.

function weapon:getSpeed(name)
	for i=1, #self.namelist do
		if self.namelist[i] == name then
			return weapon.speedlist[i]
		end
	end
end

--------Bullets--------

function bullet.draw()

	-- Cycle through all the bullets
	-- and draw a circle at all their positions.

	love.graphics.setColor(255, 255, 0)

	for i,v in ipairs(bullet.list) do
		if v.isDead == false then
        	love.graphics.circle("fill", v.body:getX(), v.body:getY(), 3)
        end
    end

	love.graphics.setColor(255, 255, 255)

end

function bullet.update(dt)

	-- Apply force to all the bullets.

	for i,v in ipairs(bullet.list) do

		if v.isDead == false then
			local vlist = bullet.variablelist[i]
			v.body:applyForce(vlist.dx, vlist.dy)
		end

	end

	-- Neat memory optimization.
	-- Loop through the bullet list
	-- If all of the bullets return dead
	-- Then theres no point in keeping the data, just clear it all.

	for i,v in ipairs(bullet.list) do

		if v.isDead == false then 
			break
		else
			if i == #bullet.list then

				bullet.shouldClear = true
				break
			end
		end
		bullet.shouldClear = false
	end		

	-- Clear the lists

	if bullet.shouldClear then
		bullet.list = {}
		bullet.variablelist = {}
		bullet.shouldClear = false
	end


end

function bullet.fire()

	-- Set some temporary variables.

	local startX = player.sx
	local startY = player.sy
	local mouseX = camera:getMouseX()
	local mouseY = camera:getMouseY()

	local angle = math.atan2((mouseY - startY), (mouseX - startX))

	local bulletDx = bullet.speed * math.cos(angle)
	local bulletDy = bullet.speed * math.sin(angle)

	-- Create the bullet.

	local bulletbody = love.physics.newBody(world, startX, startY, "dynamic")

	local shape	= love.physics.newRectangleShape(3, 3)
	local fixture	= love.physics.newFixture(bulletbody, shape)

	bulletbody:setBullet( true )
	bulletbody:setLinearDamping(0)
	fixture:setUserData("Bullet")
	fixture:setCategory( 2 )
	fixture:setMask( 2 )

	-- Add the bullet to the active bullet list.

	table.insert(bullet.variablelist, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})

	table.insert(bullet.list, {body = bulletbody, isDead = false})

	util.dprint("Firing Bullet")

end

function bullet:destroy(id)

	-- Set the bullet's status to dead.
	-- And delete the body.

	bullet.list[id].isDead = true
	bullet.list[id].body:destroy()

end

function bullet.contact(a, b, coll)

	-- If the collider is a bullet.
	-- and the bullet isn't dead.
	-- then set the bullets status to dead.
   
	if b:getUserData() == "Bullet" then
		local body = b:getBody()
		local collided = a:getBody()

		for i,v in ipairs(bullet.list) do
			if v.isDead == false then
				if v.body == body and collided ~= player.body and a:getUserData() ~= b:getUserData() then
					bullet:destroy(i)
				end
			end
		end
	end
end