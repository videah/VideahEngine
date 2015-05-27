--[[
	EntranceJew made this.
	https://github.com/EntranceJew/hooker
	Edited by VideahGams to fit the engines needs
]]

local hook = {
	hookTable = {},
	hookIter = pairs
	-- override this if you want globally deterministic hook iteration
}
-- this is where we store our hooks and the things that latch on to them like greedy little hellions

local function pack(...)
	return {n = select('#', ...), ...}
end

function hook.Add( eventName, identifier, func )
	--string, any, function
	if hook.hookTable[eventName]==nil then
		hook.hookTable[eventName] = {}
	end
	hook.hookTable[eventName][identifier] = func
end

function hook.Call( eventName, ... )
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

function hook.GetTable()
	return hook.hookTable()
end

function hook.Remove( eventName, identifier )
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