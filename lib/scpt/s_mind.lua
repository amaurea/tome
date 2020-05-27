-- handle the mind school

CHARM = add_spell
{
	["name"] = 	"Charm",
	["school"] = 	{SCHOOL_MIND},
	["level"] = 	1,
	["mana"] = 	1,
	["mana_max"] = 	20,
	["fail"] = 	10,
	["inertia"] = 	{ 2, 10 },
	["stick"] =
	{
			["charge"] =    { 7, 5 },
			[TV_WAND] =
			{
				["rarity"] = 		35,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 20, 40 },
			},
	},
	["spell"] = 	function()
			if get_level(CHARM, 50) >= 35 then
				return project_los(GF_CHARM, 10 + get_level(CHARM, 150))
			elseif get_level(CHARM, 50) >= 15 then
				local ret, dir = get_aim_dir()
				if ret == FALSE then return end
				return fire_ball(GF_CHARM, dir, 10 + get_level(CHARM, 150), 3)
			else
				local ret, dir = get_aim_dir()
				if ret == FALSE then return end
				return fire_bolt(GF_CHARM, dir, 10 + get_level(CHARM, 150))
			end
	end,
	["info"] = 	function()
			return "power "..(10 + get_level(CHARM, 150))
	end,
	["desc"] =	{
			"Tries to manipulate the mind of a monster to make it friendly",
			"At level 15 it turns into a ball",
			"At level 35 it affects all monsters in sight"
	}
}

CONFUSE = add_spell
{
	["name"] = 	"Confuse",
	["school"] = 	{SCHOOL_MIND},
	["level"] = 	5,
	["mana"] = 	5,
	["mana_max"] = 	30,
	["fail"] = 	20,
	["stick"] =
	{
			["charge"] =    { 3, 4 },
			[TV_WAND] =
			{
				["rarity"] = 		45,
				["base_level"] =	{ 1, 5 },
				["max_level"] =		{ 20, 40 },
			},
	},
	["spell"] = 	function()
			if get_level(CONFUSE, 50) >= 35 then
				return project_los(GF_OLD_CONF, 10 + get_level(CONFUSE, 150))
			elseif get_level(CONFUSE, 50) >= 15 then
				local ret, dir = get_aim_dir()
				if ret == FALSE then return end
				return fire_ball(GF_OLD_CONF, dir, 10 + get_level(CONFUSE, 150), 3)
			else
				local ret, dir = get_aim_dir()
				if ret == FALSE then return end
				return fire_bolt(GF_OLD_CONF, dir, 10 + get_level(CONFUSE, 150))
			end
	end,
	["info"] = 	function()
			return "power "..(10 + get_level(CONFUSE, 150))
	end,
	["desc"] =	{
			"Tries to manipulate the mind of a monster to confuse it",
			"At level 15 it turns into a ball",
			"At level 35 it affects all monsters in sight"
	}
}

ARMOROFFEAR = add_spell
{
	["name"] = 	"Armor of Fear",
	["school"] = 	SCHOOL_MIND,
	["level"] = 	10,
	["mana"] = 	10,
	["mana_max"] = 	50,
	["fail"] = 	35,
	["inertia"] = 	{ 2, 10 },
	["spell"] = 	function()
			tim_set("fear_shield",     10 + get_level(ARMOROFFEAR, 100))
			player.fear_shield.dice  =  1 + get_level(ARMOROFFEAR,   5)
			player.fear_shield.sides =  5 + get_level(ARMOROFFEAR,  20)
	end,
	["info"] = 	function()
			return "dur "..(10 + get_level(ARMOROFFEAR, 100)).." power "..(1 + get_level(ARMOROFFEAR, 5)).."d"..(5 + get_level(ARMOROFFEAR, 20))
	end,
	["desc"] =	{
			"Creates a shield of pure fear around you. Any monster attempting to hit you",
			"must save or flee",
		}
}
-- Support for armor of fear
tim_register("fear_shield", "You feel very scary!", "You suddenly feel much less scary!")
add_loadsave("player.fear_shield", { ["dice"] = 0, ["sides"] = 0 })
add_hooks
{
	[HOOK_PLAYER_ATTACKED] = function(m_idx,blow_idx)
		local fear = player.fear_shield
		if not fear or tim_get("fear_shield") == 0 then return end
		local m = m_list[m_idx+1]
		local r = race_info_idx(m.r_idx, m.ego)
		local pow = damroll(fear.dice,fear.sides)
		if band(r.flags1, RF1_UNIQUE) == 0 and band(r.flags3,RF3_NO_FEAR) == 0 and
				pow > m.level then
			msg_print(monster_desc(m,0).." recoils in terror!")
			m.monfear = m.monfear + 5 + pow - m.level
			if m.monfear > 200 then m.monfear = 200 end
		end
	end,
}

STUN = add_spell
{
	["name"] = 	"Stun",
	["school"] = 	{SCHOOL_MIND},
	["level"] = 	15,
	["mana"] = 	10,
	["mana_max"] = 	90,
	["fail"] = 	45,
	["spell"] = 	function()
			if get_level(STUN, 50) >= 40 then
				return project_los(GF_STUN, 10 + get_level(STUN, 150))
			elseif get_level(STUN, 50) >= 20 then
				local ret, dir = get_aim_dir()
				if ret == FALSE then return end
				return fire_ball(GF_STUN, dir, 10 + get_level(STUN, 150), get_level(STUN,7))
			else
				local ret, dir = get_aim_dir()
				if ret == FALSE then return end
				return fire_bolt(GF_STUN, dir, 10 + get_level(STUN, 150))
			end
	end,
	["info"] = 	function()
			return "power "..(10 + get_level(STUN, 150))
	end,
	["desc"] =	{
			"Tries to manipulate the mind of a monster to stun it",
			"At level 20 it turns into a ball",
			"At level 40 it affects all monsters in view"
	}
}

