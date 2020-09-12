extends GameObject
class_name ResObject

signal part_mined(val)

export(int) var step_mine = default_step_mine()
export(int) var gives = 1


func default_step_mine():
	return 20 


func mine():
	if hp > 0:
		self.hp -= step_mine
		emit_signal("part_mined", gives)
	

func _ready():
	pass
