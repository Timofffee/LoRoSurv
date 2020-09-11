extends KinematicBody2D
class_name GameObject

signal hp_changed(val)
signal destroyed

export(int) var hp = get_default_hp() setget set_hp
export(bool) var delete_on_destruction = true


func get_default_hp():
	return 100


func set_hp(val):
	hp = val
	emit_signal("hp_changed", val)
	if hp <= 0:
		emit_signal("destroyed", val)
		if delete_on_destruction:
			queue_free()


func _ready():
	pass
