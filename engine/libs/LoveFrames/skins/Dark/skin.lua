-- skin table
local skin = {}

-- skin info (you always need this in a skin)
skin.name = "Dark"
skin.author = "unek (who else makes loveframes skins?)"
skin.version = "1.0"
skin.base = "Basic"

-- fonts fonts fonts
local basic_font = love.graphics.newFont("engine/assets/fonts/Varela-Regular.otf", 12)

-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".skins." .. skin.name .. ".skin"))
local loveframes = require(path .. ".libraries.common")

-- the color utility
local color = require((...):gsub(skin.name .. ".skin", "Basic") .. ".color")

-- color definitions
local primary_color = color.rgb(30, 30, 30) -- used for the background, buttons, borders, etc.
local secondary_color = primary_color:lighten(65) -- text, mostly
local accent_color = color.rgb(212, 30, 29):darken(10) -- used for focused elements, shit like that. bright and colorful

-- skin directives, controls some default values of the objects
skin.directives = {}

skin.directives.text_default_color = secondary_color

skin.directives.checkbox_text_default_color = secondary_color
skin.directives.checkbox_text_default_shadowcolor = {0, 0, 0, 0}

-- controls
skin.controls = {}

skin.controls.frame_border_color = primary_color:lighten(5)
skin.controls.frame_shadow = {0, 0, 0, 110}
skin.controls.frame_background = primary_color

skin.controls.frame_title_background = skin.controls.frame_background
skin.controls.frame_title_foreground = secondary_color
skin.controls.frame_title_shadow = {0, 0, 0}


skin.controls.closebutton_background = skin.controls.frame_title_background
skin.controls.closebutton_color = skin.controls.frame_title_foreground

skin.controls.closebutton_background_hover = accent_color
skin.controls.closebutton_color_hover = {255, 255, 255}

skin.controls.closebutton_background_down = skin.controls.closebutton_background_hover:lighten(5)
skin.controls.closebutton_color_down = {255, 255, 255}


skin.controls.button_border_color = primary_color:lighten(15)
skin.controls.button_background = primary_color:lighten(10)
skin.controls.button_foreground = skin.controls.frame_title_foreground
skin.controls.button_shadow = false

skin.controls.button_border_color_hover = skin.controls.closebutton_background_hover
skin.controls.button_background_hover = skin.controls.button_background:lighten(5)
skin.controls.button_foreground_hover = skin.controls.frame_title_foreground
skin.controls.button_shadow_hover = false--{0, 0, 0}

skin.controls.button_border_color_down = skin.controls.button_border_color:darken(3)
skin.controls.button_background_down = skin.controls.button_background_hover:darken(10)
skin.controls.button_foreground_down = skin.controls.frame_title_foreground
skin.controls.button_shadow_down = false--{0, 0, 0}

skin.controls.button_border_color_disabled = primary_color:lighten(10)
skin.controls.button_background_disabled = primary_color:lighten(15)
skin.controls.button_foreground_disabled = primary_color:lighten(5)
skin.controls.button_shadow_disabled = skin.controls.button_foreground_disabled:lighten(15)


skin.controls.textinput_border_color = skin.controls.button_border_color
skin.controls.textinput_background = skin.controls.button_background
skin.controls.textinput_foreground = skin.controls.button_foreground

skin.controls.textinput_border_color_focus = skin.controls.button_border_color_hover
skin.controls.textinput_background_focus = skin.controls.textinput_background
skin.controls.textinput_foreground_focus = skin.controls.textinput_foreground

skin.controls.textinput_selection_background = skin.controls.closebutton_background_hover
skin.controls.textinput_selection_foreground = skin.controls.closebutton_color_hover

skin.controls.textinput_placeholder_color = skin.controls.textinput_border_color:lighten(8)
skin.controls.textinput_cursor_color = secondary_color


skin.controls.slider_border_color = skin.controls.button_border_color
skin.controls.slider_background = skin.controls.button_background
skin.controls.slider_foreground = accent_color


skin.controls.checkbox_border_color = skin.controls.textinput_border_color
skin.controls.checkbox_background = skin.controls.textinput_background
skin.controls.checkbox_foreground = accent_color:lighten(20)

skin.controls.checkbox_border_color_focus = accent_color
skin.controls.checkbox_background_focus = skin.controls.checkbox_background:lighten(5)
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

skin.controls.menuoption_border_color_hover = accent_color:lighten(10)
skin.controls.menuoption_background_hover = accent_color:lighten(10):alpha(70)


skin.controls.columnlist_background = skin.controls.frame_background
--skin.controls.columnlist_border_color = skin.controls.button_border_color


skin.controls.columnlistrow_border = primary_color:lighten(4)

skin.controls.columnlistrow_background = primary_color:darken(1)
skin.controls.columnlistrow_foreground = secondary_color

skin.controls.columnlistrow_background_selected = primary_color:lighten(2)
skin.controls.columnlistrow_foreground_selected = secondary_color


skin.controls.columnlistheader_background = primary_color:lighten(3)
skin.controls.columnlistheader_foreground = secondary_color

skin.controls.columnlistheader_background_down = skin.controls.columnlistheader_background:darken(2)
skin.controls.columnlistheader_foreground_down = secondary_color

skin.controls.columnlistheader_background_focus = skin.controls.columnlistheader_background:lighten(2)
skin.controls.columnlistheader_foreground_focus = secondary_color


skin.controls.scrollbar_background = primary_color:darken(2)


skin.controls.multichoice_border_color = skin.controls.button_border_color
skin.controls.multichoice_background = skin.controls.textinput_background
skin.controls.multichoice_foreground = secondary_color

skin.controls.multichoice_border_color_focus = skin.controls.textinput_border_color_focus
skin.controls.multichoice_background_focus = skin.controls.textinput_background_focus
skin.controls.multichoice_foreground_focus = secondary_color


skin.controls.multichoicelist_border_color = skin.controls.menu_border_color
skin.controls.multichoicelist_shadow = {0, 0, 0, 110}
skin.controls.multichoicelist_background = skin.controls.menuoption_background
skin.controls.multichoicelist_foreground = secondary_color


skin.controls.multichoicerow_background = skin.controls.menuoption_background
skin.controls.multichoicerow_foreground = skin.controls.menuoption_foreground

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


skin.controls.list_border_color = primary_color:lighten(10)
skin.controls.list_background = skin.controls.frame_background


skin.controls.panel_border_color = skin.controls.list_border_color
skin.controls.panel_background = primary_color:lighten(5)


skin.controls.form_border_color = skin.controls.list_border_color
skin.controls.form_background = skin.controls.frame_background

-- register the skin
loveframes.skins.Register(skin)
