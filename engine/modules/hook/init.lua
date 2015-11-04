--[[
	EntranceJew made this.
	https://github.com/EntranceJew/hooker
	Edited by VideahGams to fit the engines needs
]]

--- The hook library allows scripts to interact with game or user created events. It allows you to "hook" a function onto an event created with
-- hook.run or hook.call and run code when that events happens that either works independently or modifies the event's arguments. This is the 
-- preferred method instead of overriding functions to add your own code into it.

local hook = {
	hookTable = {},
	hookIter = pairs
	-- override this if you want globally deterministic hook iteration
}
-- this is where we store our hooks and the things that latch on to them like greedy little hellions

local function pack(...)
	return {n = select('#', ...), ...}
end

--- Add a hook to be called when an event occurs.
-- @param eventName Name of event to hook.
-- @param identifier Unique identifier, allowing you to replace or remove hooks.
-- @param func Function to be called, along with arguments.

function hook.add( eventName, identifier, func )
	--string, any, function
	if hook.hookTable[eventName]==nil then
		hook.hookTable[eventName] = {}
	end
	hook.hookTable[eventName][identifier] = func
end

--- Calls all hooks associated with the event name.
-- @param eventName The event to call hooks for.
-- @param args Arguments to be passed to hooks.
-- @return Data from called hooks.

function hook.call( eventName, ... )
	--string, varargs
	if hook.hookTable[eventName]==nil then
		-- skip processing the hook because nobody's listening
		return nil
	else
		local results
		for identifier,func in hook.hookIter(hook.hookTable[eventName]) do
			results = pack(func(...))
			results.n = nil
			if #results>0 then
				-- potential problems if relying on sandwiching a nil in the return results
				return unpack(results)
			end
		end
	end
end

--- Returns a table containing all hooks.
-- @return table: Hooks

function hook.getTable()
	return hook.hookTable
end

--- Removes a hook from given event name, using the hooks unique identifier.
-- @param eventName Event to remove hook from.
-- @param identifier Unique identifier of hook to be removed.
-- @return boolean: If removal was successful.

function hook.remove( eventName, identifier )
	--[[string, string]]
	if hook.hookTable[eventName]==nil or hook.hookTable[eventName][identifier]==nil then
		return false
	else
		hook.hookTable[eventName][identifier] = nil
	end
	-- see if the table is empty and nil it for the benefit of hook.Call's optimization
	for k,v in pairs(hook.hookTable[eventName]) do
		-- we found something, exit the function
		return true
	end
	-- if we reach this far then the table must've been empty
	hook.hookTable[eventName] = nil
	return true
end

return hook