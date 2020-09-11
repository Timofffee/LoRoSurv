extends Node2D


func _ready() -> void:
	randomize()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('shoot') and get_parent().dir == Vector2.ZERO:
		$ray.cast_to = get_parent().last_dir.normalized()*4
		yield(get_tree(), 'idle_frame')
		if $ray.is_colliding():
			var obj = $ray.get_collider()
			obj.modulate = Color(randf(),randf(),randf())
