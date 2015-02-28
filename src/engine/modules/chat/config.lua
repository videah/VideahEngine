local config = {}
config.color = {}
config.emotes = {}

config.chatWidth = 500
config.chatHeight = 300
config.chatPositionX = 15
config.chatPositionY = _G.screenHeight - config.chatHeight - 15

config.cursorSpeed = 2

config.maximumChatLines = 100

config.font = love.graphics.newFont("game/data/fonts/minecraft.ttf", 16)
config.bigfont = love.graphics.newFont("game/data/fonts/minecraft.ttf", 17)

config.color.bg = {26, 26, 26, 155}
config.color.textbox = {36, 36, 36, 200}

config.emotes.enabled = false

return config