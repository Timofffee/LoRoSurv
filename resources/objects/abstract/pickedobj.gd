extends GameObject
class_name PickedObj

var item

func _ready():
	item = Item.new(name, 1)
