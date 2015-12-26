-- This code is licensed under the MIT Open Source License.

-- Copyright (c) 2015 Ruairidh Carmichael - ruairidhcarmichael@live.co.uk

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

local game = {}
game.path = ... .. '.'

local models, shader, vignette, noise, start = {}, false, false, false, 0
local using_gles = select(1, love.graphics.getRendererInfo()) == "OpenGL ES"

function game.load(args)

	print('[console] Loading developer console ...')
	game.console = require('game.console'):new(true)
	print('[console] Loaded developer console!')

	print('[resources] Loading UI Classes ...')
	game.ui = require.tree('game.ui', true)
	print('[resources] Loaded UI Classes!')

	function network.server.onConnect(id)
		print(id)
	end

	function network.server.onReceive(packet, id)

		packet = json.decode(packet)
		
		print(packet.data)
		network.server.send('pong', 'PONG', id)

	end

	function network.client.onReceive(packet)

		packet = json.decode(packet)

		print(packet.data)
		network.client.send('ping', 'PING')

	end

	if args['--dedicated'] then
		network.server.start()
	else
		network.client.start()
	end

	if CLIENT then

		-- love.graphics.setBackgroundColor(200, 200, 200)

		-- local frame = ui.Create("frame")
		-- frame:SetName("Connect")
		-- frame:ShowCloseButton(false)
		-- frame:SetSize(210, 150)
		-- frame:Center()

		-- local usernameInput = ui.Create("textinput", frame)
		-- usernameInput:SetPos(5, 30)
		-- usernameInput:SetPlaceholderText("Username")

		-- local ipInput = ui.Create("textinput", frame)
		-- ipInput:SetPos(5, 60)
		-- ipInput:SetPlaceholderText("IP Address")

		-- local button = ui.Create("button", frame)
		-- button:SetPos(5, 90)
		-- button:SetSize(200, 55)
		-- button:SetText("Connect")

		-- button.OnClick = function(object, x, y)
		-- 	local success = network.client.connect(ipInput:GetText())
		-- 	if success then
		-- 		network.client.send("ping", "PING")
		-- 		frame:Remove()
		-- 	end
		-- end

	end

	game.ui.options:show()

	local data = {
		{
			model = "game/assets/models/aesa.iqm",
			use_fresnel = true,
			textures = {
				body = "game/assets/textures/skin.png",
				dress = "game/assets/textures/dress.png"
			}
		}, {
			model = "game/assets/models/ground.iqm",
			textures = {
				ground = "game/assets/textures/ground.png"
			}
		}
	}

	local flags = {
		mipmaps = true
	}

	for _, params in ipairs(data) do
		local t = love.timer.getTime()
		local model = model.iqm.load(params.model)

		model.fresnel = params.use_fresnel and 1 or 0
		model.textures = {}
		for material, path in pairs(params.textures) do
			model.textures[material] = love.graphics.newImage(path, flags)
			model.textures[material]:setFilter("linear", "linear", 16)
		end

		table.insert(models, model)
	end

	-- Simple shader with an edge highlight.
	shader = love.graphics.newShader("game/assets/shaders/shader.glsl")

	if not using_gles then
		-- Things to pretty the demo up just a little
		-- We mix a little noise into the vignette to break up banding.
		vignette = love.graphics.newShader("game/assets/shaders/vignette.glsl")
		noise    = love.graphics.newImage("game/assets/textures/noise.png", flags)
		noise:setWrap("repeat", "repeat")
	end
	start = love.timer.getTime()

	love.graphics.setBackgroundColor(241, 244, 249)

end

function game.update(dt)

	network.update(dt)

	if love.keyboard.isDown('lctrl') and love.keyboard.isDown('l') then game.console:clear() end

end

function game.draw()

	love.graphics.push("all")

	-- Love doesn't use the depth buffer, so we need to set it up & clear it.
	-- We need depth testing so we don't have to depth-sort opaque objects.
	love.graphics.clearDepth()
	love.graphics.setDepthTest("less")
	love.graphics.setColor(255, 255, 255, 255)

	-- Disable blending.
	love.graphics.setBlendMode("replace", "premultiplied")

	-- Now we transform & update the shader params...
	-- World transform. love.graphics.{translate, rotate, scale} are hooked
	local speed = 0.25
	love.graphics.setShader(shader)

	-- View transform (camera)
	local vp = cpml.mat4():look_at(
		cpml.vec3(0, 5, 1.5), -- look from 0, 5, 1.5...
		cpml.vec3(0, 0, 1),   -- to 0, 0, 1...
		cpml.vec3.unit_z      -- and +z is up.
	)

	-- Projection
	local w, h = love.graphics.getDimensions()
	vp = vp * cpml.mat4():perspective(25, w/h, 0.01, 1000)
	shader:send("u_viewProjection", vp:to_vec4s())

	-- Model transform
	local m = cpml.mat4():rotate((love.timer.getTime() - start) * speed + math.pi / 2, cpml.vec3(0, 0, -1))
	shader:send("u_model", m:to_vec4s())

	-- You can draw the whole model as one mesh (just don't set draw
	-- range), but if you draw this way you can assign a different
	-- shader/textures per-mesh. (but at the slight expense of more
	-- draw calls - so do what's best for you)
	for _, model in ipairs(models) do
		shader:sendInt("use_fresnel", model.fresnel and 1 or 0)
		for _, buffer in ipairs(model) do
			local texture = model.textures[buffer.material]
			model.mesh:setTexture(texture) -- nil is OK
			model.mesh:setDrawRange(buffer.first, buffer.last)
			love.graphics.draw(model.mesh)
		end
	end

	-- Make sure to reset things back to how they were, or you'll
	-- have a bad time. Don't forget to reset blending, too!
	love.graphics.setDepthTest()
	love.graphics.setShader()
	love.graphics.pop()

	-- Disable vignette on GLES devices (it's slow).
	if not using_gles then
		love.graphics.setShader(vignette)
		love.graphics.setBlendMode("multiply")
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(noise, 0, 0, 0, w / noise:getWidth(), h / noise:getHeight())
	end

	-- Reset blending, shader.
	love.graphics.setBlendMode("alpha")
	love.graphics.setShader()

	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.print(string.format("FPS: %0.2f (%0.3fms)", love.timer.getFPS(), love.timer.getAverageDelta()), 5, 5)

end

function game.keypressed(key, isrepeat)

	if key == '`' and not game.console.input:GetFocus() then game.console:toggle() end
	if key == 'up' and game.console.input:GetFocus() then game.console:moveUpHistory() end
	if key == 'down' and game.console.input:GetFocus() then game.console:moveDownHistory() end

end

return game