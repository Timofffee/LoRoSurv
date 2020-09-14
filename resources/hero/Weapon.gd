extends Node2D
class_name Weapon

const MINE_AXE_DELAY = 0.3
const MAX_PICK_DISTANSE = 8.0

onready var parent = get_parent()

var ray = RayCast2D.new()

func _ready() -> void:
	add_child(ray)
	ray.collision_mask = 32
	ray.collide_with_areas = true
	ray.enabled = true
	ray.position.y = -2


func _process(delta: float) -> void:
	pass
	if Input.is_action_just_pressed('shoot') \
			and parent.state == parent.STATE.IDLE:
		var d = sign(parent.last_dir.x)
		d = d if d != 0 else 1
		ray.cast_to = Vector2(d * 6, 0)
		yield(get_tree(), 'idle_frame')
		if ray.is_colliding():
			var obj = ray.get_collider().owner
			if obj.has_method('mine') and obj.mine_type == ResObject.MINE_TYPE.AXE:
				parent.anim_player.play('axe_' + ('ld' if ray.cast_to.x < 0 else 'rd'))
				yield(get_tree().create_timer(MINE_AXE_DELAY), 'timeout')
				obj.mine()
