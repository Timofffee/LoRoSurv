extends Structure

signal open_chest
signal close_chest

var is_open = false setget set_is_open
var inventory = Inventory.new()

export(String) var code = ""


func set_is_open(val, emitter=null):
	if emitter != self:
		assert(false, 'Chest :: is_open - private property')


func open(data_inventory=[], key_prop_name="keycode"):
	for item in data_inventory:
		var keycode = item.get(key_prop_name)
		if keycode:
			if code == keycode:
				is_open = true
				emit_signal("open_chest")
				return true
	return false


func close():
	if is_open:
		is_open = false
		emit_signal("close_chest")


func _ready():
	pass
