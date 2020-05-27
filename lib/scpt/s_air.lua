-- handle the air school

GF_THICK_POIS = add_spell_type
{
	["name"]        = "thick poison",
	["color"]       = { TERM_GREEN, TERM_L_GREEN, 0 },
	["angry"]       = function() return TRUE, TRUE end,
	["monster"]     = function(who, dam, rad, y, x, monst)
		--local race = race_info_idx(monst.r_idx, monst.ego)
		local race = race_info_idx(monst.r_idx, 0)
		local pdam = dam
		local sdam = dam
		local do_pois = 0
		if magik(25) == TRUE then do_pois = (10 + randint(11) + rad) / (rad+1) end
		if band(race.flags9, RF9_SUSCEP_POIS) ~= 0 then
			pdam = pdam * 3
			do_pois = do_pois * 2
			-- if (seen) r_ptr->r_flags9 |= (RF9_SUSCEP_POIS);
		end
		if band(race.flags3, RF3_IM_POIS) ~= 0 then
			pdam = pdam / 9
			do_pois = 0
			-- if (seen) r_ptr->r_flags3 |= (RF9_IM_POIS);
		end
		if band(race.flags3,RF3_NONLIVING) ~= 0 or band(race.flags3,RF3_UNDEAD) ~= 0 then
			sdam = 0
		end
		local tdam = pdam+sdam
		local message
		if tdam > dam then message = " is hit hard."
		elseif tdam > dam/2 then message = ""
		elseif tdam > dam/4 then message = " resists."
		elseif tdam > 0 then message = " resists a lot."
		else message = " is immune!"
		end
		return TRUE, TRUE, tdam, 0, 0, 0, 0, do_pois, 0, 0, message
	end,
}

NOXIOUSCLOUD = add_spell
{
	["name"] = 	"Noxious Cloud",
	["school"] = 	{SCHOOL_AIR},
	["level"] = 	3,
	["mana"] = 	3,
	["mana_max"] = 	30,
	["fail"] = 	20,
	["stick"] =
	{
			["charge"] =    { 5, 7 },
			[TV_WAND] =
			{
				["rarity"] = 		15,
				["base_level"] =	{ 1, 15 },
				["max_level"] =		{ 25, 50 },
			},
	},
	["spell"] = 	function()
			local ret, dir, type

			ret, dir = get_aim_dir()
			if ret == FALSE then return end
			if get_level(NOXIOUSCLOUD, 50) >= 30 then type = GF_THICK_POIS
			else type = GF_POIS end
			fire_cloud(type, dir, 7 + get_level(NOXIOUSCLOUD, 75), 3, 5 + get_level(NOXIOUSCLOUD, 60), get_level(NOXIOUSCLOUD, 20))
			return TRUE
	end,
	["info"] = 	function()
			return "dam "..(7 + get_level(NOXIOUSCLOUD, 75)).." dur "..(5 + get_level(NOXIOUSCLOUD, 60)).." speed "..get_level(NOXIOUSCLOUD, 20)
	end,
	["desc"] =	{
			"Creates a radius 3 cloud of poison",
			"The cloud will persist for some turns, damaging all monsters passing by",
			"At spell level 30 it turns into a thick gas attacking all living beings"
	}
}

AIRWINGS = add_spell
{
	["name"] = 	"Wings of Winds",
	["school"] = 	{SCHOOL_AIR, SCHOOL_CONVEYANCE},
	["level"] = 	22,
	["mana"] = 	30,
	["mana_max"] = 	40,
	["fail"] = 	60,
	["stick"] =
	{
			["charge"] =    { 7, 5 },
			[TV_STAFF] =
			{
				["rarity"] = 		27,
				["base_level"] =	{ 1, 10 },
				["max_level"] =		{ 20, 50 },
			},
	},
	["inertia"] = 	{ 1, 5 },
	["spell"] = 	function()
			if get_level(AIRWINGS, 50) >= 16 then
				set_tim_fly(randint(10) + 5 + get_level(AIRWINGS, 25))
			else
				return set_tim_ffall(randint(10) + 5 + get_level(AIRWINGS, 25))
			end
			return FALSE
	end,
	["info"] = 	function()
			return "dur "..(5 + get_level(AIRWINGS, 25)).."+d10"
	end,
	["desc"] =	{
			"Grants the power of levitation",
			"At level 16 it grants the power of controlled flight"
	}
}

INVISIBILITY = add_spell
{
	["name"] = 	"Invisibility",
	["school"] = 	{SCHOOL_AIR},
	["level"] = 	16,
	["mana"] = 	10,
	["mana_max"] = 	20,
	["fail"] = 	50,
	["inertia"] = 	{ 1, 15 },
	["spell"] = 	function()
			return set_invis(randint(20) + 15 + get_level(INVISIBILITY, 50), 20 + get_level(INVISIBILITY, 50))
	end,
	["info"] = 	function()
			return "dur "..(15 + get_level(INVISIBILITY, 50)).."+d20 power "..(20 + get_level(INVISIBILITY, 50))
	end,
	["desc"] =	{
			"Grants invisibility"
	}
}

POISONBLOOD = add_spell
{
	["name"] = 	"Poison Blood",
	["school"] = 	{SCHOOL_AIR},
	["level"] = 	12,
	["mana"] = 	10,
	["mana_max"] = 	20,
	["fail"] = 	30,
	["stick"] =
	{
			["charge"] =    { 10, 15 },
			[TV_WAND] =
			{
				["rarity"] = 		45,
				["base_level"] =	{ 1, 25 },
				["max_level"] =		{ 35, 50 },
			},
	},
	["inertia"] = 	{ 1, 25 },
	["spell"] = 	function()
			local obvious = nil
		       	obvious = set_oppose_pois(randint(30) + 25 + get_level(POISONBLOOD, 25))
		       	if (get_level(POISONBLOOD, 50) >= 15) then obvious = is_obvious(set_poison(randint(30) + 25 + get_level(POISONBLOOD, 25)), obvious) end
			return obvious
       	end,
	["info"] = 	function()
			return "dur "..(25 + get_level(POISONBLOOD, 25)).."+d30"
	end,
	["desc"] =	{
			"Grants resist poison",
			"At level 15 it provides poison branding to wielded weapon"
	}
}

THUNDERSTORM = add_spell
{
	["name"] = 	"Thunderstorm",
	["school"] = 	{SCHOOL_AIR, SCHOOL_NATURE},
	["level"] = 	25,
	["mana"] = 	40,
	["mana_max"] = 	60,
	["fail"] = 	60,
	["stick"] =
	{
			["charge"] =    { 5, 5 },
			[TV_WAND] =
			{
				["rarity"] = 		85,
				["base_level"] =	{ 1,  20 },
				["max_level"] =		{ 25, 80 },
			},
	},
	["inertia"] = 	{ 2, 10 },
	-- hadde 25 i steden for 150
	["spell"] = 	function()
			return set_tim_thunder(randint(10) + 10 + get_level(THUNDERSTORM, 25), 5 + get_level(THUNDERSTORM, 10), 10 + get_level(THUNDERSTORM, 250))
	end,
	["info"] = 	function()
			return "dam "..(5 + get_level(THUNDERSTORM, 10)).."d"..(10 + get_level(THUNDERSTORM, 250)).." dur "..(10 + get_level(THUNDERSTORM, 100)).."+d10"
	end,
	["desc"] =	{
			"Charges up the air around you with electricity",
			"Each turn it will throw a thunder bolt at a random monster in sight",
			"The thunder does 3 types of damage, one third of lightning",
			"one third of sound and one third of light"
	}
}

STERILIZE = add_spell
{
	["name"] = 	"Sterilize",
	["school"] = 	{SCHOOL_AIR},
	["level"] = 	20,
	["mana"] = 	10,
	["mana_max"] = 	100,
	["fail"] = 	50,
	["stick"] =
	{
			["charge"] =    { 7, 5 },
			[TV_STAFF] =
			{
				["rarity"] = 		20,
				["base_level"] =	{ 1, 10 },
				["max_level"] =		{ 20, 50 },
			},
	},
	["spell"] = 	function()
			set_no_breeders((30) + 20 + get_level(STERILIZE, 70))
			return TRUE
	end,
	["info"] = 	function()
			return "dur "..(20 + get_level(STERILIZE, 70)).."+d30"
	end,
	["desc"] =	{
			"Prevents explosive breeding for a while."
	}
}
