extends Node2D

const MINE_AXE_DELAY = 0.3

onready var parent = get_node('../..')


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('shoot') \
			and parent.state == parent.STATE.IDLE:
		var d = sign(parent.last_dir.x)
		d = d if d != 0 else 1
		$ray.cast_to = Vector2(d * 6, 0)
		yield(get_tree(), 'idle_frame')
		if $ray.is_colliding() and $ray.get_collider().has_method('mine') and $ray.get_collider().mine_type == ResObject.MINE_TYPE.AXE:
			parent.anim_player.play('axe_' + ('ld' if $ray.cast_to.x < 0 else 'rd'))
			yield(get_tree().create_timer(MINE_AXE_DELAY), 'timeout')
			$ray.get_collider().mine()
