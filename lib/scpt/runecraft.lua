-- Three kinds of runes: shape, element, power
-- Each has a level. The combined level (L) must be < your skill (S).
-- Power starts 1, and power runes are added to this.
-- The power level P is therefore 1 + sum(power runes)
-- Shapes also add if possible.
-- Damage formula is PdR, where R = S-L.

-- Ask for runes until the element is specified. There must be
-- 0-1 power runes, 1- shape runes and 1 element rune. Since
-- an arbitrary number of shape runes can be specified, these are
-- not allowed to add any power, or one could add an arbitrary
-- amount of power by specifying the same shape again and again.
setglobal("power_chosen", FALSE)
setglobal("shape_chosen", {})
setglobal("shape_nchosen", 0)
function get_rune_spell()
	power_chosen = FALSE
	shape_chosen = {}
	shape_nchosen = 0
	local skill  = get_skill(SKILL_RUNECRAFT)
	local rune = { lvl=0, flags=bor(PROJECT_KILL, PROJECT_THRU, PROJECT_STOP),
		target=nil, self=nil, cheap=nil, easy=nil, power=1, rad=0, elem=nil,
		elvl=0, sp=0, dice={0,0} }
	while TRUE do
		local ret, item = get_item("Use which rune?", "You have no suitable runes!", USE_INVEN,
			function(obj)
				if obj.tval ~= TV_RUNE_ELEM and obj.tval ~= TV_RUNE_POWER and obj.tval ~= TV_RUNE_SHAPE then
					return FALSE
				end
				if obj.tval == TV_RUNE_POWER and power_chosen == TRUE then return FALSE end
				if obj.tval == TV_RUNE_ELEM  and shape_nchosen == 0 then return FALSE end
				if obj.tval == TV_RUNE_SHAPE and shape_chosen[obj.sval] == TRUE then return FALSE end
				return TRUE
			end)
		if ret == FALSE then return end
		obj  = get_object(item)
		kind = k_info[obj.k_idx+1]
		local f1, f2, f3, f4, f5, esp = object_flags(obj)
		-- Handle the modifier flags
		if band(f1, TR1_SPELL) ~= 0 then rune.power = rune.power + obj.pval end
		if band(f4, TR4_EASY_USE) ~= 0 then rune.easy = TRUE end
		if band(f4, TR4_CHEAPNESS) ~= 0 then rune.cheap = TRUE end
		if band(f2, RUNE2_CAN_AIM) ~= 0 then rune.target = TRUE end
		if band(f2, RUNE2_HIT_SELF) ~= 0 then rune.self = TRUE end
		if band(f2, RUNE2_BALL) ~= 0 then
			rune.rad = rune.rad + 5
			rune.flags = band(rune.flags, bnot(PROJECT_STOP))
		end
		if band(f2, RUNE2_BEAM) ~= 0 then
			rune.flags = bor(rune.flags, PROJECT_BEAM)
			rune.flags = band(rune.flags, bnot(PROJECT_STOP))
		end
		if band(f2, RUNE2_SHOWER) ~= 0 then rune.flags = bor(rune.flags, PROJECT_METEOR_SHOWER) end
		if band(f2, RUNE2_VIEW)   ~= 0 then rune.flags = bor(rune.flags, PROJECT_VIEWABLE) end
		-- Parse each rune type
		if obj.tval == TV_RUNE_ELEM then
			rune.elem = obj.sval
			rune.lvl  = rune.lvl + kind.level
		elseif obj.tval == TV_RUNE_SHAPE then
			rune.lvl    = rune.lvl    +  kind.level
		end

		if obj.tval == TV_RUNE_POWER then power_chosen = TRUE end
		if obj.tval == TV_RUNE_SHAPE then
			shape_chosen[obj.sval] = TRUE
			shape_nchosen = shape_nchosen + 1
		end
		if obj.tval == TV_RUNE_ELEM then break end
	end
	-- The total level is given by the level from each rune + the total
	-- power involved, but is halved if one of the runes has the simplicity
	-- modifier.
	rune.elvl = rune.lvl + rune.power
	if rune.easy then rune.elvl = rune.elvl / 2 end
	-- The damage dice are given by Pd(S-L)
	msg_format("lvl: %d power: %d skill %d elvl: %d", rune.lvl, rune.power, skill, rune.elvl)
	function max(a,b) if a < b then return b else return a end end
	rune.dice = { rune.power, max(1,skill-rune.elvl+get_skill(SKILL_SPELL)*2/5) }
	-- The sp cost is simply the power
	rune.sp = rune.power
	if rune.cheap then rune.sp = rune.sp / 2 end
	return rune
end

function cast_rune_spell()
	local rune = get_rune_spell()
	if not rune then return end

	local tx, ty
	if rune.target and band(rune.flags, bor(PROJECT_VIEWABLE, PROJECT_METEOR_SHOWER)) == 0 then
		local ret, dir = get_aim_dir()
		if ret == FALSE then return end
		ty, tx = get_target(dir)
		if dir == 5 then rune.flags = bor(rune.flags, PROJECT_STOP) end
	else
		ty, tx = player.py, player.px
	end

	local dam   = damroll(rune.dice[1], rune.dice[2])
	msg_format("(%d,%d): %d", rune.dice[1], rune.dice[2], dam)
	local speed = player.pspeed-110
	-- Project does not handle all the project flags itself: We must
	-- handle view and meteor explicitly.
	set_effect_speed(speed)
	project_time = 10
	if rune.self then unsafe = TRUE
		take_hit(0, "foo")
	end
	if band(rune.flags, PROJECT_VIEWABLE) ~= 0 then
		project_los(rune.elem, dam)
		if rune.self then project(0, 0, player.py, player.px, dam, rune.elem, rune.flags) end
	elseif band(rune.flags, PROJECT_METEOR_SHOWER) ~= 0 then
		project_meteor(rune.rad, rune.elem, dam, rune.flags)
	else
		project(0, rune.rad, ty, tx, dam, rune.elem, rune.flags)
	end
	unsafe = FALSE
	set_effect_speed(0)
end
