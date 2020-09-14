extends GameObject
class_name ResObject

# Используется для добываемых объектов
# Деревья, каменные глыбы и т.д.

signal part_mined(val)

export(int) var step_mine = default_step_mine()
export(int) var gives = 1

export(PackedScene) onready var picked_res_scene

enum MINE_TYPE {AXE, PICKAXE, OTHER}
export(int, "axe", "pickaxe", "other") var mine_type = 2

func default_step_mine():
	return 20


func mine():
	if hp > 0:
		self.hp -= step_mine
		assert(picked_res_scene, "%s :: picked_res_scene == null" % name)
		if picked_res_scene:
			for i in gives:
				var picked_res = picked_res_scene.instance()
				var r = clamp(4 * sqrt(randf()), 4, 4)
				var theta = randf() * 2 * PI
				var p = polar2cartesian(r, theta)
				picked_res.position = position + p

				get_parent().add_child(picked_res)
			
		emit_signal("part_mined", gives)


func _ready():
	randomize()
