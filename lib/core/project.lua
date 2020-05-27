function set_effect_speed(speed)
	if not speed then speed = 0 end
	interval_project_hack = 110+speed
end

function fire_wave(typ,dir,dam,rad,time,eff,speed)
	set_effect_speed(speed)
	%fire_wave(typ,dir,dam,rad,time,eff)
	set_effect_speed(0)
end

function fire_cloud(typ,dir,dam,rad,time,speed)
	set_effect_speed(speed)
	%fire_cloud(typ,dir,dam,rad,time)
	set_effect_speed(0)
end
