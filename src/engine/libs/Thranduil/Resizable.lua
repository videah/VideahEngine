local ui_path = tostring(...):sub(1, -10)
local Object = require(ui_path .. 'classic/classic')
local Resizable = Object:extend('Resizable')

function Resizable:resizableNew(settings)
    local settings = settings or {}
    self.resizing = false
    self.resize_hot = false
    self.resize_enter = false
    self.resize_exit = false
    self.resize_margin = settings.resize_margin or 6
    self.min_width = settings.min_width or 20
    self.min_height = settings.min_height or self.h/5
    self.resize_drag_x, self.resize_drag_y = nil, nil
    self.resize_x, self.resize_y = 0, 0
    self.resize_previous_mouse_position = nil
    self.previous_resize_hot = false
end

function Resizable:resizableUpdate(dt, parent)
    local x, y = love.mouse.getPosition()
    local sax, say, aw, ah = self.x_offset or 0, self.y_offset or 0, self.area_width or self.w, self.area_height or self.h

    if self.resizable then
        -- Check for resize_hot
        if (x >= self.x + sax and x <= self.x + sax + self.resize_margin and y >= self.y + say and y <= self.y + say + ah) or
           (x >= self.x + sax and x <= self.x + sax + aw and y >= self.y + say and y <= self.y + say + self.resize_margin) or
           (x >= self.x + sax + aw - self.resize_margin and x <= self.x + sax + aw and y >= self.y + say and y <= self.y + say + ah) or
           (x >= self.x + sax and x <= self.x + sax + aw and y >= self.y + say + ah - self.resize_margin and y <= self.y + say + ah) then
            self.resize_hot = true 
        else self.resize_hot = false end

        -- Check for resize_enter
        if self.resize_hot and not self.previous_resize_hot then
            self.resize_enter = true
        else self.resize_enter = false end

        -- Check for resize_exit
        if not self.resize_hot and self.previous_resize_hot then
            self.resize_exit = true
        else self.resize_exit = false end
    end

    if self.resize_hot and self.input:pressed('left-click') then
        self.resizing = true
        if (x >= self.x + sax and x <= self.x + sax + self.resize_margin and y >= self.y + say and y <= self.y + say + ah) then self.resize_drag_x = -1 end
        if (x >= self.x + sax and x <= self.x + sax + aw and y >= self.y + say and y <= self.y + say + self.resize_margin) then self.resize_drag_y = -1 end
        if (x >= self.x + sax + aw - self.resize_margin and x <= self.x + sax + aw and y >= self.y + say and y <= self.y + say + ah) then self.resize_drag_x = 1 end
        if (x >= self.x + sax and x <= self.x + sax + aw and y >= self.y + say + ah - self.resize_margin and y <= self.y + say + ah) then self.resize_drag_y = 1 end
    end

    if self.resizing and self.input:down('left-click') then
        local dx, dy = x - self.resize_previous_mouse_position.x, y - self.resize_previous_mouse_position.y
        if self.resize_drag_x == -1 then self.resize_x = self.resize_x + dx end
        if self.resize_drag_y == -1 then self.resize_y = self.resize_y + dy end
        if self.resize_drag_x then self.w = math.max(self.w + self.resize_drag_x*dx, self.min_width) end
        if self.resize_drag_y then self.h = math.max(self.h + self.resize_drag_y*dy, self.min_height) end
    end

    if not self.draggable then 
        if self.parent then self.x, self.y = parent.x + self.ix + self.resize_x, parent.y + self.iy + self.resize_y
        else self.x, self.y = self.ix + self.resize_x, self.iy + self.resize_y end
    end

    if self.resizing and self.input:released('left-click') then
        self.resizing = false
        self.resize_drag_x = nil
        self.resize_drag_y = nil
    end

    -- Set previous frame state
    self.previous_resize_hot = self.resize_hot
    self.resize_previous_mouse_position = {x = x, y = y}
end

return Resizable
