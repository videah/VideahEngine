-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".skins.Basic.skin"))
local loveframes = require(path .. ".libraries.common")

-- use the utf8 library
local utf8 = require(path .. ".libraries.utf8")

-- skin table
local skin = {}

-- skin info (you always need this in a skin)
skin.name = "Basic"
skin.author = "unek"
skin.version = "1.0"

-- fonts fonts fonts
local basic_font = love.graphics.newFont("engine/assets/fonts/OpenSans-Regular.ttf", 12)
local icon_font = love.graphics.newFont("engine/assets/fonts/FontAwesome.otf", 12)

-- font awesome icon list
local icons = require((...):gsub(".skin$", "") .. ".icons")

-- the color utility
local color = require((...):gsub(skin.name .. ".skin", "Basic") .. ".color")

-- add skin directives to this table
skin.directives = {}

skin.directives.text_default_color = {0, 0, 0}
skin.directives.text_default_font = basic_font
skin.directives.frame_title_height = 25
skin.directives.closebutton_margin_right = 0
skin.directives.closebutton_margin_top = 0
skin.directives.closebutton_height = skin.directives.frame_title_height
skin.directives.closebutton_width = skin.directives.closebutton_height * 1.5
skin.directives.button_height = 22
skin.directives.textinput_height = 22
skin.directives.textinput_font = basic_font
skin.directives.sliderbutton_width = 8
skin.directives.checkbox_text_default_font = basic_font
skin.directives.checkbox_text_default_color = skin.directives.text_default_color
skin.directives.checkbox_text_default_shadowcolor = {0, 0, 0, 0}
skin.directives.checkbox_width = 16
skin.directives.checkbox_height = skin.directives.checkbox_width
skin.directives.tooltip_offset_x = 0
skin.directives.tooltip_offset_y = 20
skin.directives.tooltip_padding_x = 6
skin.directives.tooltip_padding_y = 3
skin.directives.tooltip_font = basic_font
skin.directives.menu_divider_height = 4
skin.directives.menu_option_height = 22
skin.directives.columnlist_font = basic_font
skin.directives.columnlist_header_height = 22
skin.directives.columnlistrow_height = 40
skin.directives.multichoice_height = 22
skin.directives.radiobutton_text_default_font = basic_font
skin.directives.radiobutton_text_default_color = skin.directives.text_default_color
skin.directives.radiobutton_text_default_shadowcolor = {0, 0, 0, 0}
skin.directives.radiobutton_width = 16
skin.directives.radiobutton_height = skin.directives.checkbox_width


-- color definitions
local primary_color = color.rgb(255, 255, 255) -- used for the background, buttons, borders, etc.
local secondary_color = color.rgb(0, 0, 0) -- text, mostly
local accent_color = color.rgb(255, 103, 0) -- used for focused elements, shit like that. bright and colorful


skin.controls = {}

skin.controls.frame_border_color = color.rgb(90, 90, 90)
skin.controls.frame_shadow = {0, 0, 0, 60}
skin.controls.frame_background = color.rgb(240, 240, 240)

skin.controls.frame_title_background = color.rgb(60, 60, 60)
skin.controls.frame_title_foreground = color.rgb(255, 255, 255)
skin.controls.frame_title_shadow = {0, 0, 0, 0}


skin.controls.closebutton_background = skin.controls.frame_title_background
skin.controls.closebutton_color = skin.controls.frame_title_foreground

skin.controls.closebutton_background_hover = color.rgb(255, 0, 0)
skin.controls.closebutton_color_hover = {255, 255, 255}

skin.controls.closebutton_background_down = skin.controls.closebutton_background_hover:lighten(25)
skin.controls.closebutton_color_down = {255, 255, 255}


skin.controls.button_border_color = primary_color:darken(35)
skin.controls.button_background = primary_color:darken(20)
skin.controls.button_foreground = secondary_color
skin.controls.button_shadow = false

skin.controls.button_border_color_hover = skin.controls.button_border_color:lighten(5)
skin.controls.button_background_hover = skin.controls.button_background:lighten(5)
skin.controls.button_foreground_hover = secondary_color
skin.controls.button_shadow_hover = false--{0, 0, 0}

skin.controls.button_border_color_down = skin.controls.button_border_color:darken(3)
skin.controls.button_background_down = skin.controls.button_background_hover:darken(7)
skin.controls.button_foreground_down = secondary_color
skin.controls.button_shadow_down = false--{0, 0, 0}

skin.controls.button_border_color_disabled = primary_color:darken(15)
skin.controls.button_background_disabled = primary_color:darken(10)
skin.controls.button_foreground_disabled = secondary_color:lighten(45)
skin.controls.button_shadow_disabled = false


skin.controls.textinput_border_color = skin.controls.button_border_color
skin.controls.textinput_background = primary_color
skin.controls.textinput_foreground = skin.controls.button_foreground

skin.controls.textinput_border_color_focus = skin.controls.button_border_color_hover
skin.controls.textinput_background_focus = skin.controls.textinput_background
skin.controls.textinput_foreground_focus = skin.controls.textinput_foreground

skin.controls.textinput_selection_background = skin.controls.closebutton_background_hover
skin.controls.textinput_selection_foreground = skin.controls.closebutton_color_hover

skin.controls.textinput_placeholder_color = skin.controls.button_foreground_disabled
skin.controls.textinput_cursor_color = secondary_color


skin.controls.slider_border_color = skin.controls.button_border_color
skin.controls.slider_background = skin.controls.button_background
skin.controls.slider_foreground = accent_color


skin.controls.checkbox_border_color = skin.controls.textinput_border_color
skin.controls.checkbox_background = skin.controls.textinput_background
skin.controls.checkbox_foreground = accent_color:lighten(20)

skin.controls.checkbox_border_color_focus = skin.controls.checkbox_border_color
skin.controls.checkbox_background_focus = skin.controls.checkbox_foreground:lighten(47)
skin.controls.checkbox_foreground_focus = skin.controls.checkbox_foreground


skin.controls.radiobutton_border_color = skin.controls.checkbox_border_color
skin.controls.radiobutton_background = skin.controls.checkbox_background
skin.controls.radiobutton_foreground = skin.controls.checkbox_foreground

skin.controls.radiobutton_border_color_focus = skin.controls.checkbox_border_color_focus
skin.controls.radiobutton_background_focus = skin.controls.checkbox_background_focus
skin.controls.radiobutton_foreground_focus = skin.controls.checkbox_foreground_focus


skin.controls.tooltip_border_color = accent_color:lighten(10)
skin.controls.tooltip_shadow = {0, 0, 0, 60}
skin.controls.tooltip_background = primary_color:lighten(5)


skin.controls.menu_border_color = skin.controls.frame_title_background
skin.controls.menu_shadow = {0, 0, 0, 60}

skin.controls.menudivider_foreground = skin.controls.frame_title_background:lighten(10)
skin.controls.menudivider_shadow = false--skin.controls.menudivider_foreground:lighten(25)

skin.controls.menuoption_background = skin.controls.frame_title_background
skin.controls.menuoption_foreground = primary_color

skin.controls.menuoption_border_color_hover = accent_color:lighten(10)
skin.controls.menuoption_background_hover = accent_color:lighten(10):alpha(70)


skin.controls.columnlist_background = skin.controls.frame_background
--skin.controls.columnlist_border_color = skin.controls.button_border_color


skin.controls.columnlistrow_border = primary_color:darken(16)

skin.controls.columnlistrow_background = primary_color:darken(8)
skin.controls.columnlistrow_foreground = secondary_color

skin.controls.columnlistrow_background_selected = accent_color
skin.controls.columnlistrow_foreground_selected = color.rgb(255, 255, 255)


skin.controls.columnlistheader_background = skin.controls.frame_title_background
skin.controls.columnlistheader_foreground = skin.controls.frame_title_foreground

skin.controls.columnlistheader_background_down = skin.controls.columnlistheader_background:darken(7)
skin.controls.columnlistheader_foreground_down = skin.controls.columnlistheader_foreground

skin.controls.columnlistheader_background_focus = skin.controls.columnlistheader_background:lighten(7)
skin.controls.columnlistheader_foreground_focus = skin.controls.columnlistheader_foreground


skin.controls.scrollbar_background = primary_color:darken(2)


skin.controls.multichoice_border_color = skin.controls.button_border_color
skin.controls.multichoice_background = primary_color
skin.controls.multichoice_foreground = secondary_color

skin.controls.multichoice_border_color_focus = skin.controls.textinput_border_color_focus
skin.controls.multichoice_background_focus = skin.controls.textinput_background_focus
skin.controls.multichoice_foreground_focus = secondary_color


skin.controls.multichoicelist_border_color = skin.controls.button_border_color
skin.controls.multichoicelist_shadow = {0, 0, 0, 60}
skin.controls.multichoicelist_background = color.rgb(255, 255, 255)
skin.controls.multichoicelist_foreground = secondary_color


skin.controls.multichoicerow_background = skin.controls.multichoicelist_background
skin.controls.multichoicerow_foreground = secondary_color

skin.controls.multichoicerow_border_color_hover = skin.controls.menuoption_border_color_hover
skin.controls.multichoicerow_background_hover = skin.controls.menuoption_background_hover


skin.controls.tabbutton_border_color = skin.controls.frame_title_background
skin.controls.tabbutton_background = skin.controls.frame_title_background
skin.controls.tabbutton_foreground = skin.controls.frame_title_foreground

skin.controls.tabbutton_border_color_hover = skin.controls.tabbutton_border_color
skin.controls.tabbutton_background_hover = skin.controls.tabbutton_background:lighten(3)
skin.controls.tabbutton_foreground_hover = skin.controls.tabbutton_foreground

skin.controls.tabbutton_border_color_open = skin.controls.tabbutton_border_color
skin.controls.tabbutton_background_open = skin.controls.tabbutton_background:darken(3)
skin.controls.tabbutton_foreground_open = accent_color

skin.controls.tabbutton_border_color_open_hover = skin.controls.tabbutton_border_color_open
skin.controls.tabbutton_background_open_hover = skin.controls.tabbutton_background_hover
skin.controls.tabbutton_foreground_open_hover = skin.controls.tabbutton_foreground_open


skin.controls.list_border_color = skin.controls.frame_background:darken(10)
skin.controls.list_background = skin.controls.frame_background:darken(5)


skin.controls.panel_border_color = skin.controls.frame_background:darken(10)
skin.controls.panel_background = skin.controls.frame_background


skin.controls.form_border_color = skin.controls.list_border_color
skin.controls.form_background = skin.controls.frame_background

-- fix for srgb
-- no idea why this is necessary :V
for key, value in pairs(skin.controls) do
  if type(value) == "table" then
    skin.controls[key] = {unpack(value)}
  end
end

-- some shortcuts to speed up shit by maybe half a nanosecond
local floor, ceil, rectangle, setColor = math.floor, math.ceil, love.graphics.rectangle, love.graphics.setColor

local function drawBorder(x, y, w, h)
  rectangle("fill", x, y, w, h)

  -- 3d borders
  -- rectangle("fill", x, y, w, h)
  -- setColor(0, 0, 0, 120)
  -- rectangle("fill", x + 1, y + 1, w - 1, h - 1)

  -- windows 98 lol
  -- rectangle("fill", x - 1, y - 1, w + 2, h + 2)
  -- rectangle("fill", x + w - 1, y - 1, 2, h + 2)
  -- rectangle("fill", x - 1, y + h - 1, w, 2)
end

function skin.DrawScrollArea(object)

end

function skin.DrawScrollBody(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor(skin.controls.scrollbar_background)
  rectangle("fill", x, y, w, h)
end

function skin.DrawScrollBar(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local type = object:GetBarType()
  local down, hover = object.down or object.dragging, object:GetHover()

  skin.DrawButton(object)

  -- draw 3 lines, the handle
  local color
  if hover and not down then
    color = skin.controls.button_border_color_hover
  else
    color = skin.controls.button_border_color
  end

  for i = -1, 1 do
    setColor(color)
    if type == "vertical" then
      drawBorder(x + 4, y + h / 2 + i * 3, w - 8, 1)
    else
      drawBorder(x + w / 2 + i * 3, y + 4, 1, h - 8)
    end
  end
end

function skin.DrawScrollButton(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local type = object:GetScrollType()

  skin.DrawButton(object, icon_font, icons["caret-" .. type])
end

function skin.DrawMenu(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor(skin.controls.menu_shadow)
  rectangle("fill", x - 1 + 1, y - 1 + 1, w + 2, h + 2)

  setColor(skin.controls.menu_border_color)
  drawBorder(x - 1, y - 1, w + 2, h + 2)
end

function skin.DrawMenuOption(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local text = object:GetText()
  local icon = object:GetIcon()
  local type = object.option_type
  local is_sub_menu = type == "submenu_activator"
  local hover = object:GetHover() or (is_sub_menu and object.menu.visible)

  if type == "divider" then
    setColor(skin.controls.menuoption_background)
    rectangle("fill", x, y, w, h)

    local x, y, w, h = x + 5, y + h / 2 - 1, w - 10, 1
    setColor(skin.controls.menudivider_foreground)
    rectangle("fill", x, y, w, h)

    if skin.controls.menudivider_shadow then
      setColor(skin.controls.menudivider_shadow)
      rectangle("fill", x, y + 1, w, h)
    end

    object.contentheight = skin.directives.menu_divider_height
  else
    setColor(skin.controls.menuoption_background)
    rectangle("fill", x, y, w, h)

    love.graphics.setFont(basic_font)

    local tw, th = basic_font:getWidth(text), basic_font:getHeight()
    local tx, ty = x + 10, y + (h - th) / 2

    setColor(skin.controls.menuoption_foreground)
    love.graphics.print(text, tx, ty)

    object.contentheight = skin.directives.menu_option_height
    object.contentwidth = math.max(130, tw + 20)

    if is_sub_menu then
      love.graphics.setFont(icon_font)
      love.graphics.print(icons["caret-right"], x + object.contentwidth, y + (h - icon_font:getHeight()) / 2 + 1)

      object.contentwidth = object.contentwidth + 10 + icon_font:getWidth(icons["caret-right"])
    end

    if hover then
      setColor(skin.controls.menuoption_background_hover)
      rectangle("fill", x + 2, y + 1, w - 3, h - 3)

      love.graphics.setLineStyle("rough")
      setColor(skin.controls.menuoption_border_color_hover)
      rectangle("line", x + 2, y + 1, w - 3, h - 3)
    end
  end

end

function skin.DrawSlider(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local type = object:GetSlideType()
  local value = object:GetValue() / object:GetMax()
  local sh = 5

  if type == "horizontal" then
    -- border
    setColor(skin.controls.slider_border_color)
    drawBorder(x, y + (h - sh) / 2, w, sh)

    -- background
    setColor(skin.controls.slider_background)
    rectangle("fill", x + 1, y + (h - sh) / 2 + 1, w - 2, sh - 2)

    -- value
    setColor(skin.controls.slider_foreground)
    rectangle("fill", x + 1, y + (h - sh) / 2 + 1, math.max(0, math.min(w, object.internals[1].x - x)), sh - 2)
  end
end

function skin.DrawSliderButton(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  return skin.DrawButton(object)
end

function skin.DrawTextInput(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local font = object:GetFont()
  local focus = object:GetFocus()
  local showindicator = object:GetIndicatorVisibility()
  local alltextselected = object:IsAllTextSelected()
  local textx = object:GetTextX()
  local texty = object:GetTextY()
  local text = object:GetText()
  local multiline = object:GetMultiLine()
  local lines = object:GetLines()
  local placeholder = object:GetPlaceholderText()
  local vbar = object:HasVerticalScrollBar()
  local hbar = object:HasHorizontalScrollBar()
  local linenumbers = object:GetLineNumbersEnabled()
  local masked = object:GetMasked()
  local maskchar = object:GetMaskChar()
  local theight = font:getHeight()

  -- border
  setColor(focus and skin.controls.textinput_border_color_focus or skin.controls.textinput_border_color)
  drawBorder(x, y, w, h)

  setColor(focus and skin.controls.textinput_background_focus or skin.controls.textinput_background)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)

  if alltextselected then
    local bary = 0
    if multiline then
      for i=1, #lines do
        local str = lines[i]
        if masked then
          str = maskchar:rep(utf8.len(str))
        end
        local twidth = font:getWidth(str)
        if twidth == 0 then
          twidth = 5
        end
        setColor(skin.controls.textinput_selection_background)
        rectangle("fill", textx, texty + bary, twidth, theight)
        bary = bary + theight
      end
    else
      local twidth = 0
      if masked then
        twidth = font:getWidth(maskchar:rep(utf8.len(str)))
      else
        twidth = font:getWidth(text)
      end
      setColor(skin.controls.textinput_selection_background)
      rectangle("fill", textx, texty - 2, twidth, theight + 4)
    end
  end

  if showindicator and focus then
    setColor(skin.controls.textinput_cursor_color)
    rectangle("fill", object:GetIndicatorX(), object:GetIndicatorY(), 1, theight)
  end

  if not multiline then
    object:SetTextOffsetY(h/2 - theight/2)
    if object:GetOffsetX() ~= 0 then
      object:SetTextOffsetX(0)
    else
      object:SetTextOffsetX(5)
    end
  else
    if vbar then
      if object:GetOffsetY() ~= 0 then
        if hbar then
          object:SetTextOffsetY(5)
        else
          object:SetTextOffsetY(-5)
        end
      else
        object:SetTextOffsetY(5)
      end
    else
      object:SetTextOffsetY(5)
    end

    if hbar then
      if offsety ~= 0 then
        if linenumbers then
          local panel = object:GetLineNumbersPanel()
          if vbar then
            object:SetTextOffsetX(5)
          else
            object:SetTextOffsetX(-5)
          end
        else
          if vbar then
            object:SetTextOffsetX(5)
          else
            object:SetTextOffsetX(-5)
          end
        end
      else
        object:SetTextOffsetX(5)
      end
    else
      object:SetTextOffsetX(5)
    end

  end

  textx = object:GetTextX()
  texty = object:GetTextY()

  love.graphics.setFont(font)

  if alltextselected then
    setColor(skin.controls.textinput_selection_foreground)
  elseif #lines == 1 and lines[1] == "" then
    setColor(skin.controls.textinput_placeholder_color)
  else
    setColor(focus and skin.controls.textinput_foreground_focus or skin.controls.textinput_foreground)
  end

  local str = ""
  if multiline then
    for i=1, #lines do
      str = lines[i]
      if masked then
        str = maskchar:rep(utf8.len(str))
      end
      love.graphics.print(#str > 0 and str or (#lines == 1 and placeholder or ""), textx, texty + theight * i - theight)
    end
  else
    str = lines[1]
    if masked then
      str = maskchar:rep(utf8.len(str))
    end
    love.graphics.print(#str > 0 and str or placeholder, textx, texty)
  end

  --setColor(230, 230, 230, 255)
  --rectangle("fill", x + 1, y + 1, width - 2, height - 2)
end

function skin.DrawOverTextInput(object)

end

function skin.DrawMultiChoice(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local choice = object:GetChoice()
  local text = choice == "" and object:GetText() or choice
  local focus = object.haslist

  setColor(focus and skin.controls.multichoice_border_color_focus or skin.controls.multichoice_border_color)
  rectangle("fill", x, y, w, h)

  setColor(focus and skin.controls.multichoice_background_focus or skin.controls.multichoice_background)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)

  setColor(focus and skin.controls.multichoice_foreground_focus or skin.controls.multichoice_foreground)
  love.graphics.setFont(basic_font)

  local th = basic_font:getHeight()
  local tx, ty = x + 5, y + (h - th) / 2

  love.graphics.print(text, tx, ty)

  skin.DrawButton(object, icon_font, icons["caret-down"])
end

function skin.DrawMultiChoiceList(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor(skin.controls.multichoicelist_shadow)
  rectangle("fill", x + 1, y + 1, w, h)

  setColor(skin.controls.multichoicelist_border_color)
  drawBorder(x, y, w, h)

  setColor(skin.controls.multichoicelist_background)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)
end

function skin.DrawMultiChoiceRow(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local hover = object:GetHover()
  local text = object:GetText()

  love.graphics.setFont(basic_font)

  local th = basic_font:getHeight()
  local tx, ty = x + 5, y + (h - th) / 2

  setColor(skin.controls.multichoicerow_background)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)

  setColor(hover and skin.controls.multichoicerow_foreground_hover or skin.controls.multichoicerow_foreground)
  love.graphics.print(text, tx, ty)

  if hover then
    setColor(skin.controls.multichoicerow_background_hover)
    rectangle("fill", x + 3, y + 2, w - 5, h - 5)

    love.graphics.setLineStyle("rough")
    setColor(skin.controls.multichoicerow_border_color_hover)
    rectangle("line", x + 3, y + 2, w - 5, h - 5)
  end

end

function skin.DrawOverMultiChoiceList(object)

end

function skin.DrawTreeNodeButton(object)

end

function skin.DrawTabButton(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local parent = object.parent
  local current = object:GetTabNumber() == parent:GetTabNumber()
  local hover = object:GetHover()
  local text = object.text

  local border, bg, fg
  if current then
    if hover then
      border = skin.controls.tabbutton_border_color_open_hover
      bg = skin.controls.tabbutton_background_open_hover
      fg = skin.controls.tabbutton_foreground_open_hover
    else
      border = skin.controls.tabbutton_border_color_open
      bg = skin.controls.tabbutton_background_open
      fg = skin.controls.tabbutton_foreground_open
    end
  else
    if hover then
      border = skin.controls.tabbutton_border_color_hover
      bg = skin.controls.tabbutton_background_hover
      fg = skin.controls.tabbutton_foreground_hover
    else
      border = skin.controls.tabbutton_border_color
      bg = skin.controls.tabbutton_background
      fg = skin.controls.tabbutton_foreground
    end
  end

  setColor(border)
  drawBorder(x, y, w, h)

  setColor(bg)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)

  if current then
    setColor(fg)
    rectangle("fill", x + 1, y + 1, w - 2, 2)
  end

  love.graphics.setFont(basic_font)

  local tw, th = basic_font:getWidth(text), basic_font:getHeight()
  local tx, ty = x + 10, y + (h - th) / 2

  setColor(fg)
  love.graphics.print(text, tx, ty)

  object.width = tw + 20
end

function skin.DrawTree(object)

end

function skin.DrawCheckBox(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.boxwidth, object.boxheight
  local hover = object:GetHover()
  local checked = object:GetChecked()

  setColor(hover and skin.controls.checkbox_border_color_focus or skin.controls.checkbox_border_color)
  drawBorder(x, y, w, h)

  setColor(hover and skin.controls.checkbox_background_focus or skin.controls.checkbox_background)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)

  if checked then
    love.graphics.setFont(icon_font)
    setColor(hover and skin.controls.checkbox_foreground_focus or skin.controls.checkbox_foreground)

    local tw, th = icon_font:getWidth(icons.check), icon_font:getHeight()
    local tx, ty = x + (w - tw) / 2, y + (h - th) / 2

    love.graphics.print(icons.check, tx, ty)
  end
end

function skin.DrawColumnListArea(object)
end

function skin.DrawOverColumnListArea(object)
  --[[local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  love.graphics.setLineStyle("rough")
  setColor(skin.controls.columnlist_border_color)
  --rectangle("line", x + 1, y, w - 1, h)]]
end

function skin.DrawColumnList(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor(skin.controls.columnlist_background)
  rectangle("fill", x, y + 1, w, h - 1)
end

local function parse_header_text(str, hx, hwidth, tx)
  local font = love.graphics.getFont()
  local twidth = love.graphics.getFont():getWidth(str)

  if (tx + twidth) - hwidth / 2 > hx + hwidth then
    if #str > 1 then
      return parse_header_text(str:sub(1, #str - 1), hx, hwidth, tx, twidth)
    else
      return str
    end
  else
    return str
  end
end

function skin.DrawColumnListHeader(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y - 1, object.width, object.height
  local hover = object:GetHover()
  local down = object.down

  local name = parse_header_text(object:GetName(), x, w, x + w / 2, w)
  local tw, th = basic_font:getWidth(name), basic_font:getHeight()
  local tx, ty = x + (w - tw) / 2, y + (h - th) / 2

  local bg, fg
  if down then
    bg = skin.controls.columnlistheader_background_down
    fg = skin.controls.columnlistheader_foreground_down
  elseif hover then
    bg = skin.controls.columnlistheader_background_focus
    fg = skin.controls.columnlistheader_foreground_focus
  else
    bg = skin.controls.columnlistheader_background
    fg = skin.controls.columnlistheader_foreground
  end


  setColor(bg)
  rectangle("fill", x, y + 1, w, h - 1)

  -- header name
  love.graphics.setFont(basic_font)
  setColor(fg)
  love.graphics.print(name, tx, ty)
end

local function parse_row_text(str, rx, rwidth, tx1, tx2)
  local twidth = love.graphics.getFont():getWidth(str)

  if (tx1 + tx2) + twidth > rx + rwidth then
    if #str > 1 then
      return parse_row_text(str:sub(1, #str - 1), rx, rwidth, tx1, tx2)
    else
      return str
    end
  else
    return str
  end
end

function skin.DrawColumnListRow(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local font = object:GetFont()
  local column_data = object:GetColumnData()
  local tx, ty = object:GetTextX(), object:GetTextY()
  local parent = object:GetParent()
  local selected = object:GetSelected()

  local th = font:getHeight()
  object:SetTextPos(5, (h - th) / 2)

  local bg, fg
  if selected then
    bg = skin.controls.columnlistrow_background_selected
    fg = skin.controls.columnlistrow_foreground_selected
  else
    bg = skin.controls.columnlistrow_background
    fg = skin.controls.columnlistrow_foreground
  end

  setColor(bg)
  rectangle("fill", x, y, w, h)

  setColor(skin.controls.columnlistrow_border)
  rectangle("fill", x, y + h - 1, w, 1)

  love.graphics.setFont(font)
  setColor(fg)
  for k, v in ipairs(column_data) do
    local rwidth = parent.parent:GetColumnWidth(k)
    if rwidth then
      local text = parse_row_text(v, x, rwidth, x, tx)
      love.graphics.printf(text or "", x + tx, y + ty, rwidth, parent.parent:GetColumnAlign(k))
      x = x + parent.parent.children[k]:GetWidth()
    else
      break
    end
  end
end

function skin.DrawGrid(object)

end

function skin.DrawCloseButton(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local hover = object:GetHover()
  local down = object.down

  -- the background
  local bg = down and skin.controls.closebutton_background_down or (hover and skin.controls.closebutton_background_hover or skin.controls.closebutton_background)
  setColor(bg)
  rectangle("fill", x, y, w, h)

  -- X's color
  local fg = down and skin.controls.closebutton_color_down or (hover and skin.controls.closebutton_color_hover or skin.controls.closebutton_color)
  setColor(fg)

  -- middle positions
  local mx, my = x + w / 2, y + h / 2
  -- half the line length
  local length = (h / 2.5) / 2 - .5

  -- set the line style.
  love.graphics.setLineStyle("smooth")

  -- draw the X
  love.graphics.line(floor(mx - length), floor(my - length), floor(mx + length), floor(my + length))
  love.graphics.line(floor(mx + length), floor(my - length), floor(mx - length), floor(my + length))
end

function skin.DrawNumberBox(object)

end

function skin.DrawModalBackground(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor(0, 0, 0, 160)
  rectangle("fill", x, y, w, h)
end

function skin.DrawForm(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor(skin.controls.form_border_color)
  rectangle("fill", x, y, w, h)

  setColor(skin.controls.form_background)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)
end

function skin.DrawImage(object)

end

function skin.DrawTabPanel(object)

end

function skin.DrawFrame(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local bh = object.titleheight
  local name = object:GetName()
  local icon = object:GetIcon()

  -- shadow
  setColor(skin.controls.frame_shadow)
  rectangle("fill", x - 1 + 1, y - 1 + 1, w + 2, h + 2)

  -- 1px border
  setColor(skin.controls.frame_border_color)
  drawBorder(x - 1, y - 1, w + 2, h + 2)

  -- the actual frame
  setColor(skin.controls.frame_background)
  rectangle("fill", x, y, w, h)

  -- the frame title bar
  setColor(skin.controls.frame_title_background)
  rectangle("fill", x, y, w, bh)

  -- frame title
  love.graphics.setFont(basic_font)

  local th = basic_font:getHeight()
  local tx, ty = x + (bh - th) / 2, y + (bh - th) / 2

  -- shadow
  setColor(skin.controls.frame_title_shadow)
  love.graphics.print(name, tx, ty + 1)

  -- actual title
  setColor(skin.controls.frame_title_foreground)
  love.graphics.print(name, tx, ty)
end

function skin.DrawTreeNode(object)

end

function skin.DrawToolTip(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor(skin.controls.tooltip_shadow)
  rectangle("fill", x + 1, y + 1, w, h)

  setColor(skin.controls.tooltip_border_color)
  drawBorder(x, y, w, h)

  setColor(skin.controls.tooltip_background)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)
end

function skin.DrawCollapsibleCategory(object)

end

function skin.DrawText(object)

end

function skin.DrawImageButton(object)

end

function skin.DrawOverTabPanel(object)

end

-- need this font to draw a nice circle :(
local big_icon_font = love.graphics.newFont("engine/assets/fonts/FontAwesome.otf", skin.directives.radiobutton_height * 1.35)

function skin.DrawRadioButton(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.boxwidth, object.boxheight
  local hover = object:GetHover()
  local checked = object:GetChecked()

  love.graphics.setFont(big_icon_font)
  local tw, th = big_icon_font:getWidth(icons.circle), big_icon_font:getHeight()
  local tx, ty = x + (w - tw) / 2, y + (h - th) / 2

  setColor(hover and skin.controls.radiobutton_background_focus or skin.controls.radiobutton_background)
  love.graphics.print(icons.circle, tx, ty)

  setColor(hover and skin.controls.radiobutton_border_color_focus or skin.controls.radiobutton_border_color)
  love.graphics.print(icons["circle-thin"], tx, ty)

  if checked then
    love.graphics.setFont(icon_font)
    setColor(hover and skin.controls.radiobutton_foreground_focus or skin.controls.radiobutton_foreground)

    local tw, th = icon_font:getWidth(icons.circle), icon_font:getHeight()
    local tx, ty = x + (w - tw) / 2, y + (h - th) / 2

    love.graphics.print(icons.circle, tx, ty)
  end
end

function skin.DrawLineNumbersPanel(object)

end

function skin.DrawList(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor(skin.controls.list_background)
  rectangle("fill", x, y, w, h)
end

function skin.DrawOverList(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local vbar, hbar = object.vbar, object.hbar
  local bar = (vbar or hbar) and object:GetScrollBar()

  love.graphics.setLineStyle("rough")
  setColor(skin.controls.list_border_color)

  if vbar then
    -- left border
    love.graphics.line(x, y, x, y + h)

    -- upper border
    love.graphics.line(x, y, x + w - bar.width, y)

    -- bottom border
    love.graphics.line(x, y + h - 1, x + w - bar.width, y + h - 1)
  elseif hbar then
    -- left border
    love.graphics.line(x, y, x, y + h - bar.height)

    -- upper border
    love.graphics.line(x, y, x + w, y)

    -- right border
    love.graphics.line(x + w - 1, y, x + w - 1, y + h - bar.height)
  else
    rectangle("line", x, y, w, h)
  end
end

function skin.DrawPanel(object)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height

  setColor((not object.alt) and skin.controls.panel_border_color or skin.controls.list_border_color)
  rectangle("fill", x, y, w, h)

  setColor((not object.alt) and skin.controls.panel_background or skin.controls.list_background)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)
end

function skin.DrawButton(object, font, text)
  local skin = object:GetSkin()
  local x, y, w, h = object.x, object.y, object.width, object.height
  local text = object.type == "button" and object:GetText() or text or ""
  local parent = object.parent
  local is_number_box_button = parent.type == "numberbox"
  local is_tab_scroll_button = parent.type == "tabs"
  local hover = object:GetHover()
  local down = object.down or object.dragging
  local disabled

  if object.type == "button" then
    disabled = not (object:GetEnabled() and object:GetClickable())
  elseif object.type == "sliderbutton" then
    disabled = not object:GetParent():GetEnabled()
  elseif object.type == "multichoice" then
    x = x + w - 16
    w = 16
  end

  local border, bg, fg, fg_shadow

  if is_tab_scroll_button then
    border = hover and skin.controls.tabbutton_border_color_hover or skin.controls.tabbutton_border_color
    bg = hover and skin.controls.tabbutton_background_hover or skin.controls.tabbutton_background
    fg = hover and skin.controls.tabbutton_foreground_hover or skin.controls.tabbutton_foreground

  elseif disabled then
    border = skin.controls.button_border_color_disabled
    bg = skin.controls.button_background_disabled
    fg = skin.controls.button_foreground_disabled
    shadow = skin.controls.button_shadow_disabled
  elseif down then
    border = skin.controls.button_border_color_down
    bg = skin.controls.button_background_down
    fg = skin.controls.button_foreground_down
    shadow = skin.controls.button_shadow_down
  elseif hover then
    border = skin.controls.button_border_color_hover
    bg = skin.controls.button_background_hover
    fg = skin.controls.button_foreground_hover
    shadow = skin.controls.button_shadow_hover
  else
    border = skin.controls.button_border_color
    bg = skin.controls.button_background
    fg = skin.controls.button_foreground
    shadow = skin.controls.button_shadow
  end

  -- fix for scrollbar buttons overlaying scrollbar
  if object.type == "scrollbar" then
    if object.bartype == "vertical" then
      y = y + 1
      h = h - 2
    else
      x = x + 1
      w = w - 2
    end
  end

  setColor(border)
  drawBorder(x, y, w, h)

  setColor(bg)
  rectangle("fill", x + 1, y + 1, w - 2, h - 2)

  local font = font or (is_number_box_button and icon_font or basic_font)
  love.graphics.setFont(font)

  local tw, th = font:getWidth(text), font:getHeight()
  local tx, ty = x + (w - tw) / 2, y + (h - th) / 2
  --if down and not disabled and not is_number_box_button then
  --  tx, ty = tx + 1, ty + 1
  --end

  if is_number_box_button then
    text = text == "+" and icons["caret-up"] or icons["caret-down"]
  end

  if shadow then
    setColor(shadow)
    love.graphics.print(text, tx, ty + 1)
  end

  setColor(fg)
  love.graphics.print(text, tx, ty)
end

function skin.DrawProgressBar(object)

end


-- register the skin
loveframes.skins.Register(skin)
