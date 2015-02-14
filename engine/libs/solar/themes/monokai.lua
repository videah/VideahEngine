theme = {

	-- Colors --

	color = {

		panelbg 		= {39, 40, 34},
		divider			= {255, 255, 255},
		text 			= {255, 255, 255},
		number 			= {174, 129, 255},
		string 			= {230, 219, 116},
		boolean_true 	= {174, 129, 255},
		boolean_false 	= {174, 129, 255},
		border			= {255, 255, 255},
		null			= {174, 129, 255}

	},

	-- Fonts --
	font = love.graphics.newFont(16),

	-- Other --
	bg_type = "tiled-image",
	bg_image = love.graphics.newImage("game/data/images/menubg.png"),

	bar_size = 20,

	divider_gap = 10,
	divider_size = 1,

	border_enabled = true,
	border_size = 2,

	quotations = true

}

return theme