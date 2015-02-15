state = {}

state.currentState = nil

function state.setState(string)
	state.currentState = string
end

function state:getState()

	return state.currentState

end

function state:isCurrentState(string)

	if string == state.currentState then
		return true
	else
		return false
	end

end

return state