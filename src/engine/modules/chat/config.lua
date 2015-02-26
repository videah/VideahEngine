local config = {}
config.color = {}

config.chatWidth = 500
config.chatHeight = 300
config.chatPositionX = 15
config.chatPositionY = _G.screenHeight - config.chatHeight - 15

config.maximumChatLines = 100

config.font = love.graphics.newFont(16)
config.bigfont = love.graphics.newFont(17)

config.color.bg = {26, 26, 26, 200}

return config