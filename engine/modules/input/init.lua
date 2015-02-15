local input = {}

local path = ... .. '.'

input.mouse = require(path .. 'mouse')

function input.update(dt)

	input.mouse.update(dt)

end

function input.mousepressed(x, y, button)

	input.mouse.mousepressed(x, y, button)

end

input.test = true

return input