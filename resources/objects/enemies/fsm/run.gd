extends State

#var falling_timer: String = ''


#func on_timers_register() -> void:
#	falling_timer = register_timer('go_to Falling', 0.2)


func on_enter(target) -> void:
	target.play_anim('run')


func on_physics_process(target, delta: float) -> void:
	#if Input.is_action_pressed('ui_up'):
	#	go_to('Jumping')

	target.update_direction()
	target.move()

	if not target.dir:
		go_to('Idle')

	elif target.is_on_floor():
		target.play_anim('run')
		#reset_timer(falling_timer)

	#else:
	#	target.play_anim('fall')
