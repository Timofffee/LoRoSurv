extends State

func _ready():
	randomize()


func on_enter(target) -> void: #target - Animal
	print(name)
	target.play_anim('idle')
	set_meta("rnd_m_eat", randi() % 55)
	set_meta("rnd_m_sleep", randi() % 10)
	set_meta("rnd_even_h_eat", (randi() % 2) + 2)


func on_physics_process(target, delta: float) -> void:
	#if Input.is_action_pressed('ui_up'):
	#	go_to('Jumping')
	#target.update_direction()
	#target.move()
	if (target.day_night_timer_node.hour >= 6 and 
			target.day_night_timer_node.hour <= 18 and
			target.day_night_timer_node.hour % get_meta("rnd_even_h_eat") == 0 and
			target.day_night_timer_node.minute == get_meta("rnd_m_eat")):
		go_to('Eat')
	if ((target.day_night_timer_node.hour < 6 or target.day_night_timer_node.hour >= 20) and
			target.day_night_timer_node.minute == get_meta("rnd_m_sleep")):
		go_to('Sleep')
	if target.dir:
		go_to('Run')

	#elif not target.is_on_floor():
	#	go_to('Falling')
