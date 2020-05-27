-- The mana school

function get_manathrust_dam()
	return 3 + get_level(MANATHRUST, 50), 1 + get_level(MANATHRUST, 20)
end

MANATHRUST = add_spell
{
	["name"] = 	"Manathrust",
	["school"] = 	SCHOOL_MANA,
	["level"] = 	1,
	["mana"] = 	1,
	["mana_max"] =  25,
	["fail"] = 	10,
	["stick"] =
	{
			["charge"] =    { 7, 10 },
			[TV_WAND] =
			{
				["rarity"] = 		5,
				["base_level"] =	{ 1, 20 },
				--["max_level"] =		{ 15, 33 },
				["max_level"] =		{ 15, 65 },
			},
	},
	["spell"] = 	function()
			local ret, dir	

			ret, dir = get_aim_dir()
			if ret == FALSE then return end
			if has_ability(AB_ARCANE_LANCE)==1 then f = fire_beam else f = fire_bolt end
			f(GF_MANA, dir, damroll(get_manathrust_dam()))
			return TRUE
	end,
	["info"] = 	function()
			local x, y

			x, y = get_manathrust_dam()
			return "dam "..x.."d"..y
	end,
	["desc"] =	{
			"Conjures up mana into a powerful bolt",
			"The damage is irresistible and will increase with level"
		}
}

DELCURSES = add_spell
{
	["name"] = 	"Remove Curses",
	["school"] = 	SCHOOL_MANA,
	["level"] = 	10,
	["mana"] = 	20,
	["mana_max"] = 	40,
	["fail"] = 	30,
	["stick"] =
	{
			["charge"] =    { 3, 8 },
			[TV_STAFF] =
			{
				["rarity"] = 		70,
				["base_level"] =	{ 1, 5 },
				["max_level"] =		{ 15, 50 },
			},
	},
	["inertia"] = 	{ 1, 10 },
	["spell"] = 	function()
			local done

			if get_level(DELCURSES, 50) >= 20 then done = remove_all_curse()
			else done = remove_curse() end
			if done == TRUE then msg_print("The curse is broken!") end
			return done
	end,
	["info"] = 	function()
			return ""
	end,
	["desc"] =	{
			"Remove curses of worn objects",
			"At level 20 switches to *remove curses*"
		}
}

RESISTS = add_spell
{
	["name"] = 	"Elemental Shield",
	["school"] = 	SCHOOL_MANA,
	["level"] = 	20,
	["mana"] = 	17,
	["mana_max"] = 	20,
	["fail"] = 	40,
	["inertia"] = 	{ 2, 15 },
	["spell"] = 	function()
			local obvious
		       	obvious = set_oppose_fire(randint(10) + 15 + get_level(RESISTS, 50))
		       	obvious = is_obvious(set_oppose_cold(randint(10) + 15 + get_level(RESISTS, 50)), obvious)
		       	obvious = is_obvious(set_oppose_elec(randint(10) + 15 + get_level(RESISTS, 50)), obvious)
		       	obvious = is_obvious(set_oppose_acid(randint(10) + 15 + get_level(RESISTS, 50)), obvious)
			return obvious
	end,
	["info"] = 	function()
			return "dur "..(15 + get_level(RESISTS, 50)).."+d10"
	end,
	["desc"] =	{
			"Provide resistances to the four basic elements",
		}
}

-- I made this one cheaper, since most of the effort involved
-- with this spell should come from fending off attacks, not
-- starting the spell. I also reduced the inertia.
MANASHIELD = add_spell
{
	["name"] = 	"Disruption Shield",
	["school"] = 	SCHOOL_MANA,
	["level"] = 	45,
	["mana"] = 	30,
	["mana_max"] = 	30,
	["fail"] = 	90,
	["inertia"] = 	{ 6, 10},
	["spell"] = 	function()
			return set_disrupt_shield(randint(5) + 3 + get_level(MANASHIELD, 100)) end,
	["info"] = 	function()
			return "dur "..(3 + get_level(MANASHIELD, 100)).."+d5"
	end,
	["desc"] =	{
			"Uses mana instead of hp to take damage."
		}
}

-- This one can be inertia controlled, but it probably isn't worth
-- it. Especially since the inertia control timer doesn't trigger
-- more often than once every normal speed turn.
MANAGLOBE = add_spell
{
	["name"] = 	"Invulnerability",
	["school"] = 	SCHOOL_MANA,
	["level"] = 	50,
	["mana"] = 	50,
	["mana_max"] = 	100,
	["fail"] = 	90,
	["inertia"] = 	{ 9, 1},
	["spell"] = 	function()
			return set_invuln(randint(5) + 3 + get_level(MANASHIELD, 10))
	end,
	["info"] = 	function()
			return "dur "..(3 + get_level(MANASHIELD, 10)).."+d5"
	end,
	["desc"] =	{
			"Nearly perfectly deflects all damage.",
			"The spell breaks as soon as a melee, shooting, throwing or magical",
			"skill action is attempted, and lasts only a short time."
		}
}
