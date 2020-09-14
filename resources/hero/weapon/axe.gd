extends Node2D


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('shoot') \
			and get_parent().dir == Vector2.ZERO \
			and not get_parent().state == get_parent().STATE.IDLE:
		$ray.cast_to = Vector2(sign(get_parent().last_dir.x) * 6, 0)
		yield(get_tree(), 'idle_frame')
		if $ray.is_colliding():
			get_parent().anim_player.play('axe_' + ('ld' if $ray.cast_to.x < 0 else 'rd'))
			var obj = $ray.get_collider()
			obj.modulate = Color(randf(),randf(),randf())
