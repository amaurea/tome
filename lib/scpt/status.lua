-- Many things are known to the player, but hard to keep track of.
-- Whether you have probability travel on or not, for example.
-- This makes the current effects more visible

function print_effect_summary(row,col)
	-- Brands
	local i = 0
	c_put_str(TERM_DARK, "            ", row, 0)
	for k,v in player.brand do
		local name = get_gf_name(v.brand)
		local color = get_gf_color(v.brand)
		if color == TERM_DARK then color = TERM_WHITE end
		c_put_str(color, strsub(name,1,1), row, col+i)
		i = i+1
	end
	-- Others
	if player.fast > 0 then
		c_put_str(TERM_L_GREEN, "S", row, col+i)
		i = i+1
	end
	if player.prob_travel > 0 then
		c_put_str(TERM_L_RED, "P", row, col+i)
		i = i+1
	end
end
