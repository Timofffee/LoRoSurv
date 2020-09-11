extends GameObject
class_name ResourceObject

export(int) var step_mine = default_step_mine()


func default_step_mine():
	return 1


func mine():
	self.hp -= step_mine


func _ready():
	pass # Replace with function body.
