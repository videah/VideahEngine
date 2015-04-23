local ui_path = tostring(...):sub(1, -10)
local Object = require(ui_path .. 'classic/classic')
local Container = Object:extend('Container')

function Container:containerNew(settings)
    local settings = settings or {}

    self:bind('tab', 'focus-next')
    self:bind('lshift', 'previous-modifier')
    self:bind('escape', 'unselect')

    self.elements = {}
    self.currently_focused_element = nil
    self.any_selected = false
end

function Container:containerUpdate(dt, parent)
    -- Focus on elements
    if self.selected and not self.input:down('previous-modifier') and self.input:pressed('focus-next') then self:focusNext() end
    if self.selected and self.input:down('previous-modifier') and self.input:pressed('focus-next') then self:focusPrevious() end
    for i, element in ipairs(self.elements) do
        if not element.selected or not i == self.currently_focused_element then
            element.selected = false
        end
        if i == self.currently_focused_element then
            element.selected = true
        end
    end
    -- Unfocus all elements if the frame isn't being interacted with
    if not self.selected then
        for _, element in ipairs(self.elements) do
            element.selected = false
        end
    end

    -- Unselect on escape
    self.any_selected = false
    if self.selected then
        for _, element in ipairs(self.elements) do
            if element.selected then self.any_selected = true end
        end
        if self.input:pressed('unselect') then self:unselect() end
    end

    -- Update children
    if self.type == 'Scrollarea' then
        for _, element in ipairs(self.elements) do
            if element.inside_scroll_area then
                element.inside_scroll_area = nil
                element:update(dt, self)
            end
        end
    else 
        for _, element in ipairs(self.elements) do 
            element:update(dt, self) 
        end 
    end
end

function Container:containerDraw()
    for _, element in ipairs(self.elements) do element:draw() end
end

function Container:containerAddElement(element)
    element.parent = self
    table.insert(self.elements, element)
    element:update(0, self)
    return element
end

function Container:focusNext()
    for _, element in ipairs(self.elements) do if element.any_selected then return end end
    for i, element in ipairs(self.elements) do 
        if element.selected then self.currently_focused_element = i end
        element.selected = false 
    end
    if self.currently_focused_element then
        self.currently_focused_element = self.currently_focused_element + 1
        if self.currently_focused_element > #self.elements then
            self.currently_focused_element = 1
        end
    else self.currently_focused_element = 1 end
end

function Container:focusPrevious()
    for _, element in ipairs(self.elements) do if element.any_selected then return end end
    for i, element in ipairs(self.elements) do 
        if element.selected then self.currently_focused_element = i end
        element.selected = false 
    end
    if self.currently_focused_element then
        self.currently_focused_element = self.currently_focused_element - 1
        if self.currently_focused_element < 1 then
            self.currently_focused_element = #self.elements
        end
    else self.currently_focused_element = #self.elements end
end

function Container:unselect()
    for _, element in ipairs(self.elements) do if element.any_selected then return end end
    if self.any_selected then
        for _, element in ipairs(self.elements) do
            element.selected = false
            self.currently_focused_element = nil
        end
    else
        self.selected = false
    end
end

return Container
