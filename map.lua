map = {}

function map.load()

	map.directory = "maps/"
	map.currentMap = "test2"
	map.mapData = sti.new(map.directory .. map.currentMap)

	map.Speed = 500

	love.physics.setMeter(32)

	world = love.physics.newWorld(0*love.physics.getMeter(), 0*love.physics.getMeter())

	collision = map.mapData:initWorldCollision(world)

	print("Loaded map system ...")

end

function map.draw()

	map.mapData:draw()

	--map.mapData:drawWorldCollision(collision)

	--love.graphics.polygon("line", player.body:getWorldPoints(player.shape:getPoints()))

	love.graphics.setBlendMode("alpha")

end

function map.update(dt)

	map.ftx, map.fty = math.floor(camera.x), math.floor(camera.y)

	world:update(dt)

end

function map:changeMap(string)

	map.currentMap = string
	map.mapData = sti.new(map.directory .. map.currentMap)

	world = love.physics.newWorld(0*love.physics.getMeter(), 0*love.physics.getMeter())

	collision = map.mapData:initWorldCollision(world)
	player.x = 0
	player.y = 0
	player.sx = 0
	player.sy = 0

end