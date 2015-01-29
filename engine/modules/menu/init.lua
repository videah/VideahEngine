menu = {}

local path = ... .. "."

menu.config = require(path .. 'config') -- Load menu config.

function menu.draw()

end

function menu.update(dt)

print(menu.config.title)

end

return menu