extends KinematicBody2D
class_name GameObject

# Является родительским классом для остальных объектов

signal hp_changed(val)
signal destroyed

export(int) var hp = get_max_hp() setget set_hp
export(bool) var delete_on_destruction = true

export(NodePath) onready var ground_tilemap setget set_ground_tilemap
onready var parent = get_parent()
var day_night_timer_node


func set_ground_tilemap(val):
	if typeof(val) in [TYPE_NODE_PATH, TYPE_STRING]:
		if val:
			yield(self, "tree_entered")
			ground_tilemap = get_node(val)
	else:
		ground_tilemap = val


func get_max_hp():
	return 100


func set_hp(val):
	hp = val
	emit_signal("hp_changed", val)
	if hp <= 0:
		emit_signal("destroyed", val)
		if delete_on_destruction:
			queue_free()


func _enter_tree():
	if get_tree().current_scene.has_node('DayNightCycle'):
		day_night_timer_node = get_tree().current_scene.get_node('DayNightCycle')

func _ready():
	set_meta("default_hp", hp)
