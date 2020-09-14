extends State


func on_enter(target) -> void: #target - Animal
	print(name)
	target.play_anim('eat')
	set_meta("start_time", target.day_night_timer_node.get_timestamp())


func on_physics_process(target, delta: float):
	var dt = target.day_night_timer_node.get_timestamp() - get_meta("start_time")
	if dt % 20 == 0 and dt != 0:
		go_to('Idle')
