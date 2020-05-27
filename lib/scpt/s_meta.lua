-- handle the meta school

RECHARGE = add_spell
{
	["name"] = 	"Recharge",
	["school"] = 	{SCHOOL_META},
	["level"] = 	5,
	["mana"] = 	10,
	["mana_max"] = 	100,
	["fail"] = 	20,
	["spell"] = 	function()
			return recharge(60 + get_level(RECHARGE, 140))
	end,
	["info"] = 	function()
			return "power "..(60 + get_level(RECHARGE, 140))
	end,
	["desc"] =	{
			"Taps on the ambient mana to recharge an object's power (charges or mana)",
	}
}

--function get_spellbinder_max()
--	local i
--	i = get_level(SPELLBINDER, 4)
--	if i > 4 then i = 4 end
--	return i
--end
--'
--SPELLBINDER = add_spell
--{
--	["name"] = 	"Spellbinder",
--	["school"] = 	{SCHOOL_META},
--	["level"] = 	20,
--	["mana"] = 	100,
--	["mana_max"] = 	300,
--	["fail"] = 	85,
--	["spell"] = 	function()
--			local i, ret, c
--
--			if player.spellbinder_num ~= 0 then
--				local t =
--				{
--					[SPELLBINDER_HP75] = "75% HP",
--					[SPELLBINDER_HP50] = "50% HP",
--					[SPELLBINDER_HP25] = "25% HP",
--				}
--				msg_print("The spellbinder is already active.")
--				msg_print("It will trigger at "..t[player.spellbinder_trigger]..".")
--				msg_print("With the spells: ")
--				for i = 1, player.spellbinder_num do
--					msg_print(spell(player.spellbinder[i]).name)
--				end
--				return TRUE
--			end
--
--			ret, c = get_com("Trigger at [a]75% hp [b]50% hp [c]25% hp?", strbyte("a"))
--			if ret == FALSE then return TRUE end
--			
--			if c == strbyte("a") then
--				player.spellbinder_trigger = SPELLBINDER_HP75
--			elseif c == strbyte("b") then
--				player.spellbinder_trigger = SPELLBINDER_HP50
--			elseif c == strbyte("c") then
--				player.spellbinder_trigger = SPELLBINDER_HP25
--			else
--				return
--			end
--			player.spellbinder_num = get_spellbinder_max()
--			i = player.spellbinder_num
--			while i > 0 do
--				local s
--
--				s = get_school_spell("bind", "is_ok_spell", 0)
--				if s == -1 then
--					player.spellbinder_trigger = 0
--					player.spellbinder_num = 0
--					return TRUE
--				else
--					if spell(s).skill_level > 7 + get_level(SPELLBINDER, 35) then
--						msg_print("You are only allowed spells with a base level of "..(7 + get_level(SPELLBINDER, 35))..".");
--						return TRUE
--					end
--				end
--				player.spellbinder[i] = s
--				i = i - 1
--			end
--			player.energy = player.energy - 3100;
--			msg_print("Spellbinder ready.")
--			return TRUE
--	end,
--	["info"] = 	function()
--			return "number "..(get_spellbinder_max()).." max level "..(7 + get_level(SPELLBINDER, 35))
--	end,
--	["desc"] =	{
--			"Stores spells in a trigger.",
--			"When the condition is met all spells fire off at the same time",
--			"This spell takes a long time to cast so you are advised to prepare it",
--			"in a safe area.",
--			"Also it will use the mana for the Spellbinder and the mana for the",
--			"selected spells"
--	}
--}

DISPERSEMAGIC = add_spell
{
	["name"] = 	"Disperse Magic",
	["school"] = 	{SCHOOL_META},
	["level"] = 	15,
	["mana"] = 	30,
	["mana_max"] = 	60,
	["fail"] = 	40,
	-- Unnafected by blindness
	["blind"] =     FALSE,
	-- Unnafected by confusion
	["confusion"] = FALSE,
	["stick"] =
	{
			["charge"] =    { 5, 5 },
			[TV_WAND] =
			{
				["rarity"] = 		25,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 5, 40 },
			},
	},
	["inertia"] = 	{ 1, 5 },
	["spell"] = 	function()
			local obvious
			obvious = set_blind(0)
			obvious = is_obvious(set_lite(0), obvious)
			if get_level(DISPERSEMAGIC, 50) >= 5 then
				obvious = is_obvious(set_confused(0), obvious)
				obvious = is_obvious(set_image(0), obvious)
			end
			if get_level(DISPERSEMAGIC, 50) >= 10 then
				obvious = is_obvious(set_slow(0), obvious)
				obvious = is_obvious(set_fast(0, 0), obvious)
				obvious = is_obvious(set_light_speed(0), obvious)
			end
			if get_level(DISPERSEMAGIC, 50) >= 15 then
				obvious = is_obvious(set_stun(0), obvious)
				obvious = is_obvious(set_meditation(0), obvious)
				obvious = is_obvious(set_cut(0), obvious)
			end
			if get_level(DISPERSEMAGIC, 50) >= 20 then
				obvious = is_obvious(set_hero(0), obvious)
				obvious = is_obvious(set_shero(0), obvious)
				obvious = is_obvious(set_blessed(0), obvious)
				obvious = is_obvious(set_shield(0, 0, 0, 0, 0), obvious)
				obvious = is_obvious(set_afraid(0), obvious)
				obvious = is_obvious(set_parasite(0, 0), obvious)
				obvious = is_obvious(set_mimic(0, 0, 0), obvious)
			end
			return TRUE
	end,
	["info"] = 	function()
			return ""
	end,
	["desc"] =	{
			"Dispels a lot of magic that can affect you, be it good or bad",
			"Level 1: blindness and light",
			"Level 5: confusion and hallucination",
			"Level 10: speed (both bad or good) and light speed",
			"Level 15: stunning, meditation, cuts",
			"Level 20: hero, super hero, bless, shields, afraid, parasites, mimicry",
	}
}

TRACKER = add_spell
{
	["name"] = 	"Tracker",
	["school"] = 	{SCHOOL_META, SCHOOL_CONVEYANCE},
	["level"] = 	30,
	["mana"] = 	50,
	["mana_max"] = 	50,
	["fail"] = 	95,
	["spell"] = 	function()
			if last_teleportation_y == -1 then
				msg_print("There has not been any teleporatation here.")
				return TRUE
			end
			teleport_player_to(last_teleportation_y, last_teleportation_x)
			return TRUE
	end,
	["info"] = 	function()
			return ""
	end,
	["desc"] =	{
			"Tracks down the last teleportation that happened on the level and teleports",
			"you to it",
	}
}

--hack! due to apparent loadsave limitations, we only support
--12 spells
add_loadsave("player.inertia_control_store",
{
	["num"] = 0,
	["a0"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a1"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a2"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a3"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a4"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a5"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a6"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a7"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a8"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a9"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a10"] = { ["spell"] = 0, ["countdown"] = 1 },
	["a12"] = { ["spell"] = 0, ["countdown"] = 1 }
}
)
player.inertia_controlled_spells = {}
build_inertia_control = function()
	for i = 0, player.inertia_control_store.num-1 do
		local spell, countdown = player.inertia_control_store["a"..i].spell, player.inertia_control_store["a"..i].countdown
		player.inertia_controlled_spells[spell] =
		{
			["spell"] = spell,
			["timer"] = new_timer
			{
				["enabled"] = TRUE,
				["delay"] = __tmp_spells[spell].inertia[2],
				["countdown"] = countdown,
				["callback"] = function()
					if (player.wild_mode == FALSE) then
						__spell_spell[%spell]()
					end
				end,
			},
		}
	end
end
flatten_inertia_control = function()
	local i = 0
	for k,v in player.inertia_controlled_spells do
		player.inertia_control_store["a"..i].spell = k
		player.inertia_control_store["a"..i].countdown = v.timer.countdown
		i = i+1
	end
	player.inertia_control_store.num = i
end

add_inertia_controlled_spell = function(spell, interval)
	if player.inertia_controlled_spells[spell] then return TRUE end
	player.inertia_controlled_spells[spell] =
	{
		["spell"] = spell,
		["timer"] = new_timer
		{
			["enabled"] = TRUE,
			["delay"] = interval,
			["countdown"] = 1,
			["callback"] = function()
				if (player.wild_mode == FALSE) then
					__spell_spell[%spell]()
				end
			end,
		},
	}
	flatten_inertia_control()
end
remove_inertia_controlled_spell = function(spell)
	if player.inertia_controlled_spells[spell] == nil then return end
	player.inertia_controlled_spells[spell].timer.enabled = FALSE
	player.inertia_controlled_spells[spell] = nil
	flatten_inertia_control()
end

stop_inertia_controlled_spells = function()
	for k,v in player.inertia_controlled_spells do
		v.timer.enabled = FALSE
	end
	player.inertia_controlled_spells = {}
	player.update = bor(player.update, PU_MANA)
	flatten_inertia_control()
	return TRUE
end

print_inertia_controlled_spells = function(left, offset)
	local fmt = "%-1s%-1s %-20s   %-7s %-8s  %s"
	local i = 0
	local c = strbyte("a")-1
	c_prt(TERM_WHITE, format(fmt, "", "", "Spell", "Inertia",
		"Msp cost", "Description"),offset,left)
	for s,v in player.inertia_controlled_spells do
		i = i+1
		c_prt(TERM_L_GREEN, format(fmt, strchar(c+i), ")", spell(s).name,
			__tmp_spells[s].inertia[1], __tmp_spells[s].inertia[1]*get_mana(s),
			__spell_info[s]()),offset+i,left)
	end
end

add_hooks
{
	-- Reduce the mana by four times the cost of the spell
	[HOOK_CALC_MANA] = function(msp)
		for k,v in player.inertia_controlled_spells do
			player.msp = player.msp - (get_mana(v.spell) * __tmp_spells[v.spell].inertia[1])
			--msp = msp - get_mana(v.spell)*get_mana(v.spell)*100/msp/v.timer.delay
		end
	end,

	[HOOK_LOAD_END] = function()
		build_inertia_control()
		return FALSE
	end,

	-- Stop a previous spell at birth
	[HOOK_BIRTH_OBJECTS] = function()
		stop_inertia_controlled_spells()
	end,
}

INERTIA_CONTROL = add_spell
{
	["name"] = 	"Inertia Control",
	["school"] = 	{SCHOOL_META},
	["level"] = 	37,
	["mana"] = 	0, -- to avoid not having enough mana to stop using it (was 300,700)
	["mana_max"] = 	0,
	["fail"] = 	95,
	["spell"] = 	function()
			if next(player.inertia_controlled_spells) then
				ret, c = get_com("Add a spell [a], remove a spell [b] or stop control [c]?", strbyte("a"))
				if ret == FALSE then return TRUE end
				if c == strbyte("c") then
					msg_print("You stop your inertia control.")
					return stop_inertia_controlled_spells()
				elseif c == strbyte("b") then
					screen_save()
					local left = 0
					print_inertia_controlled_spells(left,1)
					ret, k = get_com("Stop controlling which spell?", -1)
					screen_load()
					if ret == FALSE or k == -1 then return TRUE end
					-- get the corresponding spell. This is a bit
					-- clumsy, I think. I just don't know lua well enough
					local si = k-strbyte("a")
					local i = 0
					local s
					for st, foo in player.inertia_controlled_spells do
						if i == si then
							s = st
							break
						end
						i = i+1
					end
					if not s then return TRUE end
					remove_inertia_controlled_spell(s)
					msg_print("You stop inertia controlling "..spell(s).name..".")
					return TRUE
				elseif c ~= strbyte("a") then return TRUE
				end
			end

			local s = get_school_spell("control", "is_ok_spell", 0)
			if s == -1 then return TRUE end

			local inertia = __tmp_spells[s].inertia

			if inertia == nil then
				msg_print("This spell inertia flow can not be controlled.")
				return TRUE
			end
			inert_total = 0
			for k,v in player.inertia_controlled_spells do
				inert_total = inert_total + __tmp_spells[v.spell].inertia[1]
			end
			if inert_total+inertia[1] > get_level(INERTIA_CONTROL, 10) then
				if not next(player.inertia_controlled_spells) then
					msg_print("This spell inertia flow("..inertia[1]..") is too strong to be controlled by your current spell.")
				else
					msg_print("Adding this spell ("..inertia[1]..") to the ones you are already controlling ("..inert_total..") would overwhelm your current inertia control.")
				end
				return TRUE
			end

			add_inertia_controlled_spell(s, inertia[2])
			player.update = bor(player.update, PU_MANA)
			msg_print("Inertia flow controlling spell "..spell(s).name..".")
			return TRUE
	end,
	["info"] = 	function()
			return "level "..get_level(INERTIA_CONTROL, 10)
	end,
	["desc"] = 	{
			"Changes the energy flow of a spell to be continuously recasted",
			"at a given interval. The inertia controlled spell reduces your",
			"maximum mana by four times its cost.",
	}
}

-- Improved spellbinder. Very similar to inertia control above, but
-- I'll not try to generalize before I have at least two real
-- implementaions

function shift_aarray(array, shift, pos)
	local n = array.num
	if pos > n then return end
	if shift > 0 then
		for i = n-1, pos do
			array["a"..i+shift] = array["a"..i]
		end
	elseif shift < 0 then
		for i = pos, n+shift-1 do
			array["a"..i] = array["a"..i-shift]
		end
	end
	array.num = n + shift
end

function setup_aarray(location, struct)
	setglobal(location, struct)
	add_loadsave(location, struct)
end

spellbinder_max_num = 8
setup_aarray("player.spellbinder2",
{
	["num"] = 0,
	["a0"] =  { ["spell"] = 0, ["trigger"] = 0, ["v1"] = 0, ["v2"] = 0 },
	["a1"] =  { ["spell"] = 0, ["trigger"] = 0, ["v1"] = 0, ["v2"] = 0 },
	["a2"] =  { ["spell"] = 0, ["trigger"] = 0, ["v1"] = 0, ["v2"] = 0 },
	["a3"] =  { ["spell"] = 0, ["trigger"] = 0, ["v1"] = 0, ["v2"] = 0 },
	["a4"] =  { ["spell"] = 0, ["trigger"] = 0, ["v1"] = 0, ["v2"] = 0 },
	["a5"] =  { ["spell"] = 0, ["trigger"] = 0, ["v1"] = 0, ["v2"] = 0 },
	["a6"] =  { ["spell"] = 0, ["trigger"] = 0, ["v1"] = 0, ["v2"] = 0 },
	["a7"] =  { ["spell"] = 0, ["trigger"] = 0, ["v1"] = 0, ["v2"] = 0 },
}
)

player.spellbinder2 = {}
function get_num_spellbinder() return player.spellbinder2.num end
function get_bound_spell(i) return player.spellbinder2["a"..i] end
add_spellbinder_spell = function(pos, bspell)
	shift_aarray(player.spellbinder2, 1, pos)
	player.spellbinder2["a"..pos] = {
		["spell"]   = bspell.spell,
		["trigger"] = bspell.trigger,
		["v1"]      = bspell.v1,
		["v2"]      = bspell.v2
	}
end
remove_spellbinder_spell = function(pos)
	shift_aarray(player.spellbinder2, -1, pos)
end
function move_spellbinder_spell(from, to)
	local spell = player.spellbinder2["a"..from]
	remove_spellbinder_spell(from)
	add_spellbinder_spell(to, spell)
end

trigger_type_store = { }
function add_trigger_type(info)
	local i = getn(trigger_type_store)+1
	trigger_type_store[i] = info
	return i-1
end
function get_trigger_type(i)
	return trigger_type_store[i+1]
end
function num_trigger_types() return getn(trigger_type_store) end

function get_alpha_ind(question, from, to)
	screen_save()
	while TRUE do
		ret, c = get_com(question, -1)
		if ret == FALSE or c == -1 then screen_load() return end
		c = c - strbyte("a")
		if c >= from and c <= to then screen_load() return c end
	end
end

function setup_trigger_frac()
	local i = get_alpha_ind("Trigger at a) 25% b) 50% c) 75%", 0, 2)
	if not i then return end
	return { ["v1"] = 25*(i+1), ["v2"] = 0 }
end

add_trigger_type{
	["name"] = "HP",
	["help"] = "Triggers based on HP%",
	["desc"] = function(bspell) return "Hp <= "..bspell.v1.."%" end,
	["setup"] = setup_trigger_frac,
	["condition"] = function(bspell)
		return 100*player.chp/player.mhp <= bspell.v1
	end
}

add_trigger_type{
	["name"] = "SP",
	["help"] = "Triggers based on SP%",
	["desc"] = function(bspell) return "Sp <= "..bspell.v1.."%" end,
	["setup"] = setup_trigger_frac,
	["condition"] = function(bspell)
		return 100*player.csp/player.msp <= bspell.v1
	end
}

function process_spellbinder()
	local i = 0
	while i < get_num_spellbinder() do
		local b = get_bound_spell(i)
		local info = get_trigger_type(b.trigger)
		if info.condition(b) then
			local s = b.spell
			cmsg_print(TERM_YELLOW, ""..spell(s).name .. " triggers!")
			remove_spellbinder_spell(i)
			cast_school_spell(s, spell(s), TRUE, nil)
		else
			i = i + 1
		end
	end
end

function get_spellbinder_trigger()
	while TRUE do
		local fmt = "%-1s%-1s %-10s %s"
		local c = strbyte("a")-1
		screen_save()
		c_prt(TERM_WHITE, format(fmt, "", "", "Name", "Description"),0,0)
		for i = 0, num_trigger_types()-1 do
			local ttype = get_trigger_type(i)
			c_prt(TERM_L_GREEN, format(fmt, strchar(c+i+1), ")", ttype.name,
				ttype.help),i+1,0)
		end
		c = get_alpha_ind("Trigger based on what condition?", 0, num_trigger_types()-1)
		screen_load()
		if not c then return end
		local t = get_trigger_type(c)
		screen_save()
		local tinfo = t.setup()
		screen_load()
		if tinfo then
			tinfo.trigger = c
			return tinfo
		end
	end
end

-- Max number of spells
function get_spellbinder_max_num() return get_level(SPELLBINDER, 4) end
-- Max level of spells
function get_spellbinder_max_level() return 7 + get_level(SPELLBINDER, 35) end

function control_spellbinder()
	local c
	local d
	while TRUE do
		screen_save()
		print_spellbinder(0,1)
		ret, c = get_com("(a)dd, (r)emove or (m)ove a spell?", -1)
		screen_load()
		if ret == FALSE or c == -1 then return TRUE end
		if c == strbyte("a") then
			if get_num_spellbinder() >= get_spellbinder_max_num() then
				msg_print("You have already bound as many spells as you can.")
				return TRUE
			end
			while TRUE do
				local trigger = get_spellbinder_trigger()
				if not trigger then break end
				local s = get_school_spell("bind", "is_ok_spell", 0)
				if s ~= -1 then
					if spell(s).skill_level > get_spellbinder_max_level() then
						msg_print("You are only allowed spells with a base level of "..(7 + get_level(SPELLBINDER, 35))..".")
						return TRUE
					end
					trigger.spell = s
					if cast_school_spell(s, spell(s), nil, TRUE) then
						add_spellbinder_spell(get_num_spellbinder(), trigger)
						msg_print("Successfully bound spell.")
						return TRUE
					else
						return FALSE
					end
				end
			end
		elseif c == strbyte("r") then
			screen_save()
			print_spellbinder(0,1)
			c = get_alpha_ind("Remove which spell?", 0, get_num_spellbinder()-1)
			screen_load()
			if c then remove_spellbinder_spell(c) end
		elseif c == strbyte("m") then
			screen_save()
			print_spellbinder(0,1)
			c = get_alpha_ind("Move which spell?", 0, get_num_spellbinder()-1)
			if c then d = get_alpha_ind("Move spell to?", 0, get_num_spellbinder()-1) end
			screen_load()
			if c and d then move_spellbinder_spell(c,d) end
		end
	end
end

function print_spellbinder(left, up)
	local fmt = "%-1s%-1s %-20s %-15s %s"
	local c = strbyte("a")-1
	c_prt(TERM_WHITE, format(fmt, "", "", "Spell",
		"Trigger", "Description"),up,left)
	local db = "spellbinder2"
	for j = 0, player[db].num-1 do
		local info = player[db]["a"..j]
		local s    = info.spell
		local tstr = get_trigger_type(info.trigger).desc(info)
		c_prt(TERM_L_GREEN, format(fmt, strchar(c+j+1), ")", spell(s).name,
			tstr, __spell_info[s]()),up+j+1,left)
	end
end

a=control_spellbinder


SPELLBINDER = add_spell
{
	["name"] = 	"Spellbinder",
	["school"] = 	{SCHOOL_META},
	["level"] = 	20,
	["mana"] = 	30,
	["mana_max"] = 	60,
	["fail"] = 	85,
	["spell"] = control_spellbinder,
	["info"] = 	function()
		return "Up to "..get_spellbinder_max_num().." level "..get_spellbinder_max_level().." spells"
	end,
	["desc"] = 	{
		"Spells cast through spellbinder are suspended until their",
		"trigger condition is met, at which point they fire off",
		"immediately. This spell can also be used to list the currently",
		"suspended spells, reorder them, or cancel them. When adding",
		"new spells, beware that the spell is effectively cast at that",
		"time, so its failure rate and mana cost also applies."
	}
}


add_hooks
{
	-- Do not pass triggers to children
	[HOOK_BIRTH_OBJECTS] = function()
		player.spellbinder2.num = 0
	end,
	[HOOK_HP_CHANGED] = process_spellbinder,
	[HOOK_SP_CHANGED] = process_spellbinder,
}
