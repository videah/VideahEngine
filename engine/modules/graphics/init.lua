graphics = {}

function graphics.newImage(filename)

	local image = nil

	if love.filesystem.exists(filename) then

		image = love.graphics.newImage(filename)

	else

		local missingtexture = 'engine/data/images/missing.png'

		assert(love.filesystem.exists(missingtexture), "CRITICAL ERROR: cannot load missing texture")

		image = love.graphics.newImage(missingtexture)

	end

	return image

end

return graphics