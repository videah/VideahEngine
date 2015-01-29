state = {}

print("Loaded gamestate system ...")

state.currentState = "splash"

-- Change the current gamestate.

function state:changeState(input)
	self.currentState = input
end

-- Get the current gamestate.

function state:getState()
	return self.currentState
end	

-- Check if the current gamestate is a certain one.

function state:isStateEnabled(input)
	if input == self.currentState then
		return true
	else
		return false
	end
end