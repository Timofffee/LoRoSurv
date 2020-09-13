extends Node2D

onready var shadow_node = $shadow
export(int, 0, 128, 1) var shadow_width = 2
export(int, 0, 128, 1) var shadow_length = 10

var day_night_timer_node
onready var anim = $anim


func update_shadow(val):
	if shadow_width != shadow_node.scale.y:
		shadow_node.scale.y = shadow_width
	
	var timestamp = day_night_timer_node.get_day_timestamp()
	if anim.current_animation!="": #fix "Condition'!Playback.current.from'is true."
		anim.seek(timestamp / 1000.0)
	

func _ready() -> void:
	if get_tree().current_scene.has_node('DayNightCycle'):
		day_night_timer_node = get_tree().current_scene.get_node('DayNightCycle')
		anim.current_animation = "dn_cycle"
		day_night_timer_node.connect('new_minute', self, 'update_shadow')
