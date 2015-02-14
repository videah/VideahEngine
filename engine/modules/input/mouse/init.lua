mouse = {}
mouse.bindlist = {}

-- Probaby better ways of doing this. --
mouse.clickedbutton = nil

function mouse.bind(button, action)

	for i=1, #mouse.bindlist do

		if mouse.bindlist[i].action == action then
			table.remove(mouse.bindlist, i)
		end

	end

	local tbl = {key = button, action = action}
	table.insert(mouse.bindlist, tbl)

end

function mouse.isBindDown(action)

	for i=1, #mouse.bindlist do
		if mouse.bindlist[i].action == action then
			if love.mouse.isDown(mouse.bindlist[i].key) then
				return true
			else
				return false
			end
		end
	end
end

function mouse.isBindClicked(action)

	for i=1, #mouse.bindlist do
		if mouse.bindlist[i].action == action then
			if mouse.clickedbutton == mouse.bindlist[i].key then
				return true
			else
				return false
			end
		end
	end
end

function mouse.mousepressed(x, y, button)

	mouse.clickedbutton = button

end

function mouse.update(dt)

	--mouse.clickedbutton = nil

end



return mouse