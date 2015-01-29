splash = {}
splash.splashlist = {}
splash.imagelist = {}
splash.transparency = 0
splash.count = 0

-- Load an image file and add them to a list
-- to create a splash screen.

function splash:newSplash(file)

	table.insert(splash.splashlist, file)

	table.insert(splash.imagelist, love.graphics.newImage(file))

	util.dprint("Loaded splashimage " .. file .. "...")

end

-- Start the tween + load create the actual splash's.

function splash.load()

	splash:newSplash("data/images/splashes/videahenginesplash.png")

	splash:newSplash("data/images/splashes/love.png")

	splash.fade()

end

function splash.draw()

	love.graphics.setColor(0,0,0,255)

	love.graphics.rectangle("fill", 0, 0, global.screenWidth, global.screenHeight)

	-- Cycle through the splash list.

	for i=1, #splash.splashlist do

		love.graphics.setColor(255,255,255,splash.transparency)

		-- If the current splash is the one in the list.

		if splash.count == i then

			-- Then grab the splash from the list and draw it to the screen.

			love.graphics.draw(splash.imagelist[i], (global.screenWidth / 2) - (splash.imagelist[i]:getWidth() / 2), (global.screenHeight / 2) - (splash.imagelist[i]:getHeight() / 2))

		end

	end

	love.graphics.setColor(255,255,255,255)

	-- If all the splash screens have been drawn
	-- Then change the state to something else (Like a main menu).

	if splash.count > #splash.splashlist then
		state:changeState("menu")
	end

end

-- Temporary splash skip.

function splash.keypressed(key, isrepeat)

	if key == " " or key == "return" or key == "escape" then
		splash.fadetween:stop()
		splash.transparency = 0
		splash.fade()
	end

end

-- Fade in and out splash screens.

function splash.fade()

	splash.count = splash.count + 1

	if splash.count <= #splash.splashlist then
		splash.fadetween = flux.to(splash, 2, { transparency = 255 })
		:after(splash, 1.5, { transparency = 0 })
		:oncomplete(splash.fade)
	end

end
