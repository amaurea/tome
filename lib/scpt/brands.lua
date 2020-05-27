add_loadsave("player.brand_store",
{
	["a0"] = { ["rad"] = 0, ["dam"] = 0, ["brand"] = 0, ["flag"] = 0, ["dur"] = 0 },
	["a1"] = { ["rad"] = 0, ["dam"] = 0, ["brand"] = 0, ["flag"] = 0, ["dur"] = 0 },
	["a2"] = { ["rad"] = 0, ["dam"] = 0, ["brand"] = 0, ["flag"] = 0, ["dur"] = 0 },
	["a3"] = { ["rad"] = 0, ["dam"] = 0, ["brand"] = 0, ["flag"] = 0, ["dur"] = 0 },
	["a4"] = { ["rad"] = 0, ["dam"] = 0, ["brand"] = 0, ["flag"] = 0, ["dur"] = 0 },
	["a5"] = { ["rad"] = 0, ["dam"] = 0, ["brand"] = 0, ["flag"] = 0, ["dur"] = 0 },
	["a6"] = { ["rad"] = 0, ["dam"] = 0, ["brand"] = 0, ["flag"] = 0, ["dur"] = 0 },
	["a7"] = { ["rad"] = 0, ["dam"] = 0, ["brand"] = 0, ["flag"] = 0, ["dur"] = 0 }
}
)
player.brand = {}
build_brand = function()
	for i = 0, 7 do
		local foo = player.brand_store["a"..i]
		local brand = foo.brand
		if (foo.dur ~= 0) then
			player.brand[brand] = {
				["rad"] = foo.rad,
				["dam"] = foo.dam,
				["brand"] = foo.brand,
				["flag"] = foo.flag,
				["dur"] = foo.dur
			}
		end
	end
end

flatten_brand = function()
	local i = 0
	for k,v in player.brand do
		player.brand_store["a"..i].rad = v.rad
		player.brand_store["a"..i].dam = v.dam
		player.brand_store["a"..i].brand = v.brand
		player.brand_store["a"..i].flag = v.flag
		player.brand_store["a"..i].dur = v.dur
		i=i+1
	end
	while i < 8 do
		player.brand_store["a"..i].dur = 0
		i=i+1
	end
end

print_brand = function()
	local fmt = "%-3s %-4s %-20s %s"
	local i = 0
	c_prt(TERM_WHITE, format(fmt, "Rad", "dam", "brand", "dur"),i,0)
	i=i+1
	for k,v in player.brand do
		c_prt(TERM_L_GREEN, format(fmt, v.rad, v.dam, get_gf_name(v.brand), v.dur), i, 0)
		i = i+1
	end
end

has_project = function(gf) if player.brand[gf] then return 1 else return end end
brand_active = has_project

add_brand = function(rad, dam, brand, flag, dur)
	if (brand ~= 0) then
		if brand_active(brand) then
			msg_print("Your weapon is re-imbued with "..get_gf_name(brand))
		else
			msg_print("Your weapon is imbued with "..get_gf_name(brand))
		end
		player.brand[brand] =
		{
			["rad"] = rad,
			["dam"] = dam,
			["brand"] = brand,
			["flag"] = flag,
			["dur"] = dur
		}
		player.redraw = bor(player.redraw, PR_EXTRA)
		redraw_stuff()
	end
end

remove_brand = function(brand)
	msg_print("Your weapon is no longer imbued with "..get_gf_name(brand))
	player.brand[brand] = nil
	player.redraw = bor(player.redraw, PR_EXTRA)
	redraw_stuff()
end

process_brand = function()
	for k,v in player.brand do
		if(v.dur > 0) then v.dur = v.dur-1 end
		if(v.dur == 0) then remove_brand(v.brand) end
	end
end

project_brand = function(x,y)
	for k,v in player.brand do
		project(0, v.rad, y, x, v.dam, v.brand, v.flag)
	end
end


add_hooks
{
	[HOOK_PROCESS_WORLD] = function()
		process_brand()
		return FALSE
	end,

	[HOOK_LOAD_END] = function()
		build_brand()
		return FALSE
	end,

	[HOOK_SAVE_START] = function()
		flatten_brand()
		return FALSE
	end,

	-- Stop a previous spell at birth
	[HOOK_BIRTH_OBJECTS] = function()
		player.brand = {}
	end,
}
