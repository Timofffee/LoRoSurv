extends GameObject
class_name ResObject

# Используется для добываемых объектов
# Деревья, каменные глыбы и т.д.

signal part_mined(val)

export(int) var step_mine = default_step_mine()
export(int) var gives = 1

export(PackedScene) onready var picked_res_scene


func default_step_mine():
	return 20


func mine():
	if hp > 0:
		self.hp -= step_mine
		assert(picked_res_scene, "%s :: picked_res_scene == null" % name)
		if picked_res_scene:
			for i in gives:
				var picked_res = picked_res_scene.instance()
				picked_res.position = position + Vector2(
						(randi() % 8) + (4 * GDHelpers.rnd_sign()), 
						(randi() % 8) + (4 * GDHelpers.rnd_sign())
				)
				get_parent().add_child(picked_res)
			
		emit_signal("part_mined", gives)


func _ready():
	randomize()
