extends State


func on_enter(target) -> void: #target - Animal
	print(name)
	target.play_anim('sleep')
	set_meta("rnd_m_to_idle", randi() % 10)


func on_physics_process(target, delta: float) -> void:
	if ((target.day_night_timer_node.hour >= 6 and
		target.day_night_timer_node.hour < 20) and 
		target.day_night_timer_node.minute == get_meta("rnd_m_to_idle")):
		go_to('Idle')
