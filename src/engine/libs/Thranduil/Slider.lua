local ui_path = tostring(...):sub(1, -7)
local Object = require(ui_path .. 'classic/classic')
local Base = require(ui_path .. 'Base')
local Draggable = require(ui_path .. 'Draggable')
local Resizable = require(ui_path .. 'Resizable')
local Slider = Object:extend('Slider')
Slider:implement(Base)
Slider:implement(Draggable)
Slider:implement(Resizable)

function Slider:new(ui, x, y, w, h, settings)
    self.ui = ui
    self.id = self.ui.addToElementsList(self)
    self.type = 'Slider'

    self:basePreNew(x, y, w, h, settings)
    self:bind('left', 'move-left')
    self:bind('right', 'move-right')

    self.draggable = settings.draggable or false
    if self.draggable then self:draggableNew(settings) end
    self.resizable = settings.resizable or false
    if self.resizable then self:resizableNew(settings) end

    self.value = settings.value or 0
    self.value_interval = settings.value_interval or 1
    self.max_value = settings.max_value or self.w
    self.min_value = settings.min_value or 0
    self.repeat_interval = settings.repeat_interval or 0.2
    self.slider_x = ((self.value - self.min_value)/(self.max_value - self.min_value))*(self.w) + self.x 

    self:basePostNew()
end

function Slider:update(dt, parent)
    self:basePreUpdate(dt, parent)
    local x, y = love.mouse.getPosition()

    if self.resizable then self:resizableUpdate(dt, parent) end
    if self.draggable then self:draggableUpdate(dt, parent) end

    -- Check for move left/right
    if self.selected and self.input:pressed('move-left') then
        self.pressed_time = love.timer.getTime()
        self:moveLeft()
    end
    if self.selected and self.input:down('move-left') then
        local d = love.timer.getTime() - self.pressed_time
        if d > self.repeat_interval then self:moveLeft() end
    end
    if self.selected and self.input:pressed('move-right') then
        self.pressed_time = love.timer.getTime()
        self:moveRight()
    end
    if self.selected and self.input:down('move-right') then
        local d = love.timer.getTime() - self.pressed_time
        if d > self.repeat_interval then self:moveRight() end
    end

    -- Change value
    if self.hot and self.down then
        self.value = ((x - self.x)/(self.w))*(self.max_value - self.min_value) + self.min_value
        self.value = self.value_interval*math.ceil(self.value/self.value_interval)
    end

    self.slider_x = ((self.value - self.min_value)/(self.max_value - self.min_value))*(self.w) + self.x 

    self:basePostUpdate(dt)
end

function Slider:draw()
    self:baseDraw()
end

function Slider:moveLeft()
    self.value = math.max(self.value - self.value_interval, self.min_value)
end

function Slider:moveRight()
    self.value = math.min(self.value + self.value_interval, self.max_value)
end

return Slider

