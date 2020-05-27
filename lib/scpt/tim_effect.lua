-- Lua version of timed effects. Provides a ser of numbers that
-- decrease by 1 every turn while positive, and print a set and
-- expire message. No other effects are handled here. This is meant
-- as a building block, not a complete solution.

tim_effects = {}

function tim_do_msg(msg, name)
	if not msg then return end
	if type(msg) == "function" then
		msg(name)
	else
		msg_print(msg)
	end
end

add_hooks
{
	[HOOK_PROCESS_WORLD] = function()
		for name, tim in tim_effects do
			if tim.time > 0 then
				tim.time = tim.time - 1
				if tim.time == 0 then tim_do_msg(tim.lose, name) end
			end
		end
	end,
}

-- All registers must happen statically at the beginning for loadsave
-- to work.
function tim_register(name, gain, lose)
	tim = { ["gain"] = gain, ["lose"] = lose, ["time"] = 0 }
	tim_effects[name] = tim
	add_loadsave("tim_effects."..name..".time", 0)
end

function tim_set(name, time)
	local tim = tim_effects[name]
	assert(tim, "No such tim: "..name)
	if tim.time ~= 0 and time == 0 then
		tim_do_msg(tim.lose, name)
	elseif tim.time == 0 and time ~= 0 then
		tim_do_msg(tim.gain, name)
	end
	tim_effects[name].time = time
end

function tim_get(name)
	local tim = tim_effects[name]
	assert(tim, "No such tim: "..name)
	return tim.time
end
