-- Counter attacks for monks. After level 30, monks get a
-- (level-30)*5 % chance of counterattacking with a single
-- strike. Above level 45, the attacs become pre-emptive
function roll_counter_nhits()
	local chance = (get_skill(SKILL_HAND)-30)*5
	return chance/100 + magik(chance-chance/100*100)
end
add_hooks
{
	[HOOK_PLAYER_HIT] = function(m_idx,blow_idx)
		if get_skill(SKILL_HAND) >= 30 and get_skill(SKILL_HAND) < 45 then
			local n = roll_counter_nhits()
			local m = m_list[m_idx+1]
			if n > 0 then py_attack(m.fy, m.fx, n) end
		end
	end,
	[HOOK_PLAYER_ATTACKED] = function(m_idx,blow_idx)
		if get_skill(SKILL_HAND) >= 45 then
			local n = roll_counter_nhits()
			local m = m_list[m_idx+1]
			if n > 0 then py_attack(m.fy, m.fx, n) end
		end
	end,
}
