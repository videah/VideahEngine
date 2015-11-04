--[[------------------------------------------------
  -- Love Frames - A GUI library for LOVE --
  -- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".skins.NeonOrange.skin"))
local loveframes = require(path .. ".libraries.common")

-- skin table
local skin = {}

-- skin info (you always need this in a skin)
skin.name = "NeonOrange"
skin.author = "unek (who else makes loveframes skins?)"
skin.version = "1.0"
skin.base = "Basic"

-- the color utility
local color = require((...):gsub(skin.name .. ".skin", "Basic") .. ".color")

-- color definitions
local primary_color = color.rgb(255, 103, 0):spin(145):darken(10) -- used for the background, buttons, borders, etc.
local secondary_color = color.rgb(30, 30, 30) -- text, mostly
local accent_color = color.rgb(60, 60, 60) -- used for focused elements, shit like that. bright and colorful

-- skin directives, controls some default values of the objects
skin.directives = {}

skin.directives.text_default_color = {0, 0, 0}

skin.directives.checkbox_text_default_color = {0, 0, 0}
skin.directives.checkbox_text_default_shadowcolor = {0, 0, 0, 0}

-- controls
skin.controls = {}

skin.controls.frame_border_color = secondary_color
skin.controls.frame_shadow = {0, 0, 0, 110}
skin.controls.frame_background = primary_color

skin.controls.frame_title_background = skin.controls.frame_background
skin.controls.frame_title_foreground = secondary_color
skin.controls.frame_title_shadow = primary_color:lighten(15)


skin.controls.closebutton_background = skin.controls.frame_title_background
skin.controls.closebutton_color = skin.controls.frame_title_foreground

skin.controls.closebutton_background_hover = accent_color
skin.controls.closebutton_color_hover = {255, 255, 255}

skin.controls.closebutton_background_down = skin.controls.closebutton_background_hover:lighten(5)
skin.controls.closebutton_color_down = {255, 255, 255}


skin.controls.button_border_color = accent_color:lighten(10)
skin.controls.button_background = accent_color
skin.controls.button_foreground = primary_color
skin.controls.button_shadow = accent_color:darken(15)

skin.controls.button_border_color_hover = skin.controls.button_border_color
skin.controls.button_background_hover = skin.controls.button_background:lighten(2)
skin.controls.button_foreground_hover = skin.controls.button_foreground
skin.controls.button_shadow_hover = skin.controls.button_shadow

skin.controls.button_border_color_down = skin.controls.button_border_color:lighten(3)
skin.controls.button_background_down = skin.controls.button_background_hover:lighten(7)
skin.controls.button_foreground_down = skin.controls.button_foreground
skin.controls.button_shadow_down = false--{0, 0, 0}

skin.controls.button_border_color_disabled = skin.controls.button_border_color
skin.controls.button_background_disabled = skin.controls.button_background
skin.controls.button_foreground_disabled = skin.controls.button_background_disabled:lighten(15)
skin.controls.button_shadow_disabled = false


skin.controls.textinput_border_color = accent_color:lighten(16)
skin.controls.textinput_background = accent_color
skin.controls.textinput_foreground = primary_color

skin.controls.textinput_border_color_focus = primary_color:darken(10)
skin.controls.textinput_background_focus = accent_color
skin.controls.textinput_foreground_focus = skin.controls.textinput_foreground

skin.controls.textinput_selection_background = skin.controls.closebutton_background_hover
skin.controls.textinput_selection_foreground = skin.controls.closebutton_color_hover

skin.controls.textinput_placeholder_color = skin.controls.textinput_background:lighten(15)
skin.controls.textinput_cursor_color = skin.controls.textinput_foreground


skin.controls.slider_border_color = accent_color
skin.controls.slider_background = skin.controls.button_background
skin.controls.slider_foreground = primary_color:lighten(8)


skin.controls.checkbox_border_color = skin.controls.button_border_color
skin.controls.checkbox_background = skin.controls.button_background
skin.controls.checkbox_foreground = primary_color

skin.controls.checkbox_border_color_focus = skin.controls.button_border_color_hover
skin.controls.checkbox_background_focus = skin.controls.button_background_hover
skin.controls.checkbox_foreground_focus = skin.controls.checkbox_foreground


skin.controls.tooltip_border_color = accent_color:lighten(10)
skin.controls.tooltip_shadow = {0, 0, 0, 110}
skin.controls.tooltip_background = primary_color:lighten(5)


skin.controls.menu_border_color = skin.controls.button_border_color
skin.controls.menu_shadow = {0, 0, 0, 110}

skin.controls.menudivider_foreground = skin.controls.menu_border_color
skin.controls.menudivider_shadow = skin.controls.menu_border_color:darken(10)

skin.controls.menuoption_background = skin.controls.button_background
skin.controls.menuoption_foreground = skin.controls.button_foreground

skin.controls.menuoption_border_color_hover = primary_color:lighten(10)
skin.controls.menuoption_background_hover = primary_color:lighten(10):alpha(70)


skin.controls.columnlist_background = skin.controls.frame_background
--skin.controls.columnlist_border_color = skin.controls.button_border_color


skin.controls.columnlistrow_background_even = primary_color:darken(5)
skin.controls.columnlistrow_foreground_even = secondary_color

skin.controls.columnlistrow_background_odd = primary_color:lighten(5)
skin.controls.columnlistrow_foreground_odd = secondary_color

skin.controls.columnlistrow_background_selected = accent_color:lighten(5)
skin.controls.columnlistrow_foreground_selected = primary_color


skin.controls.columnlistheader_background = accent_color
skin.controls.columnlistheader_foreground = primary_color

skin.controls.columnlistheader_background_down = skin.controls.columnlistheader_background:darken(2)
skin.controls.columnlistheader_foreground_down = primary_color

skin.controls.columnlistheader_background_focus = skin.controls.columnlistheader_background:lighten(2)
skin.controls.columnlistheader_foreground_focus = primary_color


skin.controls.scrollbar_background = accent_color:darken(5)


skin.controls.multichoice_border_color = skin.controls.textinput_border_color
skin.controls.multichoice_background = skin.controls.textinput_background
skin.controls.multichoice_foreground = skin.controls.textinput_foreground

skin.controls.multichoice_border_color_focus = skin.controls.textinput_border_color_focus
skin.controls.multichoice_background_focus = skin.controls.textinput_background_focus
skin.controls.multichoice_foreground_focus = primary_color


skin.controls.multichoicelist_border_color = skin.controls.menu_border_color
skin.controls.multichoicelist_shadow = {0, 0, 0, 110}
skin.controls.multichoicelist_background = skin.controls.menuoption_background
skin.controls.multichoicelist_foreground = secondary_color


skin.controls.multichoicerow_background = skin.controls.menuoption_background
skin.controls.multichoicerow_foreground = skin.controls.menuoption_foreground

skin.controls.multichoicerow_border_color_hover = skin.controls.menuoption_border_color_hover
skin.controls.multichoicerow_background_hover = skin.controls.menuoption_background_hover


-- register the skin
loveframes.skins.Register(skin)

