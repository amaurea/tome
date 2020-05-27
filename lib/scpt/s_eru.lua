-- H

get_item_degree = function(o)
		if is_known(o) == FALSE then return -1 end
		local deg = 0
		if o.name2 > 0 or o.name2b > 0 then deg = 1 end
		if is_artifact(o) == TRUE then deg = 2 end
		if o.name1 ~= 0 then
			if a_info[o.name1].set ~= -1 then deg = 3 end
			if band(a_info[o.name1].flags4,TR4_ULTIMATE) ~= 0 then deg = 4 end
		end
		return deg
end

get_item_letter_color = function(obj)
	local d = get_item_degree(obj)
	if d == 4 then return TERM_VIOLET
	elseif d == 3 then return TERM_GREEN
	elseif d == 2 then return TERM_YELLOW
	elseif d == 1 then return TERM_L_BLUE
	elseif d == -1 then return TERM_SLATE
	else return TERM_WHITE end
end

ERU_REMEMBER = add_spell
{
	["name"] = 	"Remember the Music",
	["school"] = 	{SCHOOL_ERU},
	["level"] = 	1,
	["mana"] = 	0,
	["mana_max"] = 	0,
	["fail"] = 	0,
	-- Uses piety to cast
	["piety"] =     TRUE,
	["stat"] =      A_WIS,
	-- Unnafected by blindness
	["blind"] =     FALSE,
	["random"] = 	SKILL_SPIRITUALITY,
	["spell"] = 	function()
			local strong
			if get_level(ERU_REMEMBER) >= 45 then strong = TRUE end
			local known = { }
			-- start at 2 because the first entry (1 here, 0 in C) is
			-- reserved. Which items are displayed?
			-- Truly identified objects + other objects if visible
			-- all objects if skill >= 50
			pass = function(o)
				if o.k_idx == 0 then return end
				if get_level(ERU_REMEMBER) >= 50 then return TRUE end
				if band(o.ident, IDENT_KNOWN) ~= 0 then return TRUE end
				if o.held_m_idx ~= 0 then if m_list[o.held_m_idx+1].ml == TRUE then return TRUE end
				elseif o.marked == TRUE then return TRUE end
			end
			for i = 2, o_max do if pass(o_list[i]) then tinsert(known, o_list[i]) end end
			sfunc = function(o1,o2)
				local s1, s2 = get_item_degree(o1), get_item_degree(o2)
				if s1 == s2 then
					if o1.tval == o2.tval then
						if o1.sval == o2.sval then
							return object_desc(o1,-1,0) < object_desc(o2,-1,0)
						else return o1.sval < o2.sval end
					else return o1.tval < o2.tval end
				else return s1 > s2 end
			end
			sort(known, sfunc)

			-- now display the lists
			screen_save()

			local mline = 23
			local page = 0
			local mpage = (getn(known)-1)/mline
			local a = strbyte("a")-1

			while TRUE do
				c_prt(TERM_WHITE,format("Displaying page %s of known items on this level.", page+1),0,0)
				for i = 1, mline do
					local j = i + mline*page
					if j <= getn(known) then
						local o = known[j]
						-- display letter
						c_prt(get_item_letter_color(o),format("%-1s)",strchar(a+i)),i,0)
						-- display symbol
						c_prt(object_attr(o),strchar(object_char(o)),i,3)
						-- display name
						local tvalhack = o.tval
						if tvalhack > 128 then tvalhack = 0 end
						local col = tval_to_attr[tvalhack+1]
						if col == 0 then col = TERM_WHITE end
						c_prt(col, format(" %-74s",
								object_desc(known[j],1,2)),i,4)
						-- display location
						if o.held_m_idx == 0 then
							if o.marked == TRUE or strong then 
								c_prt(TERM_WHITE,format("  %3s %3s",o.ix,o.iy),i,40)
								c_prt(TERM_WHITE,"on ground",i,51)
							else
								c_prt(TERM_WHITE,"    ?   ?",i,40)
								c_prt(TERM_WHITE,"unknown",i,51)
							end
						else
							local m = m_list[o.held_m_idx+1]
							if m.ml == TRUE or strong then
								c_prt(TERM_WHITE,format("  %3s %3s", m.fx, m.fy),i,40)
								c_prt(TERM_WHITE,monster_desc(m,136),i,51)
							else
								c_prt(TERM_WHITE,"    ?   ?",i,40)
								c_prt(TERM_WHITE,"unknown",i,51)
							end
						end
					else c_prt(TERM_WHITE, format("%-80s",""),i,0) end
				end
				local key = inkey()
				if key == ESCAPE then break
				elseif key == strbyte(" ") then
					page = page + 1
					if page > mpage then page = 0 end
				end
			end
			screen_load()
			return TRUE
	end,
	["info"] = 	function()
			return ""
	end,
	["desc"] =	{
			"Lets you remember what you already know of the great music",
			"from which the world originates, reminding you of allitems",
			"(except those you already carry) on the current level. At",
			"level 45 you will remember the location of identified objects",
			"you do not know where are. At level 50 it will reveal the",
			"location of all items on the level."
	}
}
ERU_SEE = add_spell
{
	["name"] = 	"See the Music",
	["school"] = 	{SCHOOL_ERU},
	["level"] = 	1,
	["mana"] = 	1,
	["mana_max"] = 	50,
	["fail"] = 	20,
	-- Uses piety to cast
	["piety"] =     TRUE,
	["stat"] =      A_WIS,
	-- Unnafected by blindness
	["blind"] =     FALSE,
	["random"] = 	SKILL_SPIRITUALITY,
	["spell"] = 	function()
			local obvious
			obvious = set_tim_invis(randint(20) + 10 + get_level(ERU_SEE, 100))
			if get_level(ERU_SEE) >= 30 then
				wiz_lite_extra()
				obvious = TRUE
			elseif get_level(ERU_SEE) >= 10 then
				map_area()
				obvious = TRUE
			end
			if get_level(ERU_SEE) >= 20 then
				obvious = is_obvious(set_blind(0), obvious)
			end
			return obvious
	end,
	["info"] = 	function()
			return "dur "..(10 + get_level(ERU_SEE, 100)).."+d20"
	end,
	["desc"] =	{
			"Allows you to 'see' the Great Music from which the world",
			"originates, allowing you to see unseen things",
			"At level 10 it allows you to see your surroundings",
			"At level 20 it allows you to cure blindness",
			"At level 30 it allows you to fully see all the level"
	}
}

ERU_LISTEN = add_spell
{
	["name"] = 	"Listen to the Music",
	["school"] = 	{SCHOOL_ERU},
	["level"] = 	7,
	["mana"] = 	15,
	["mana_max"] = 	200,
	["fail"] = 	25,
	-- Uses piety to cast
	["piety"] =     TRUE,
	["stat"] =      A_WIS,
	["random"] = 	SKILL_SPIRITUALITY,
	["spell"] = 	function()
			if get_level(ERU_LISTEN) >= 30 then
				ident_all()
				identify_pack()
				return TRUE
			elseif get_level(ERU_LISTEN) >= 14 then
				identify_pack()
				return TRUE
			else
				return ident_spell()
			end
	end,
	["info"] = 	function()
			return ""
	end,
	["desc"] =	{
			"Allows you to listen to the Great Music from which the world",
			"originates, allowing you to understand the meaning of things",
			"At level 14 it allows you to identify all your pack",
			"At level 30 it allows you to identify all items on the level",
	}
}

ERU_UNDERSTAND = add_spell
{
	["name"] = 	"Know the Music",
	["school"] = 	{SCHOOL_ERU},
	["level"] = 	30,
	["mana"] = 	200,
	["mana_max"] = 	600,
	["fail"] = 	50,
	-- Uses piety to cast
	["piety"] =     TRUE,
	["stat"] =      A_WIS,
	["random"] = 	SKILL_SPIRITUALITY,
	["spell"] = 	function()
			if get_level(ERU_UNDERSTAND) >= 10 then
				identify_pack_fully()
				return TRUE
			else
				return identify_fully()
			end
	end,
	["info"] = 	function()
			return ""
	end,
	["desc"] =	{
			"Allows you to understand the Great Music from which the world",
			"originates, allowing you to know the full abilities of things",
			"At level 10 it allows you to *identify* all your pack",
	}
}

ERU_PROT = add_spell
{
	["name"] = 	"Lay of Protection",
	["school"] = 	{SCHOOL_ERU},
	["level"] = 	35,
	["mana"] = 	400,
	["mana_max"] = 	400,
	["fail"] = 	80,
	-- Uses piety to cast
	["piety"] =     TRUE,
	["stat"] =      A_WIS,
	["random"] = 	SKILL_SPIRITUALITY,
	["spell"] = 	function()
			return fire_ball(GF_MAKE_GLYPH, 0, 1, 1 + get_level(ERU_PROT, 2, 0))
	end,
	["info"] = 	function()
			return "rad "..(1 + get_level(ERU_PROT, 2, 0))
	end,
	["desc"] =	{
			"Creates a circle of safety around you",
	}
}
