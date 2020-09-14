extends Node2D

onready var shadow_node = $shadow
export(int, 0, 128, 1) var shadow_width = 2
export(int, 0, 128, 1) var shadow_length = 10
export(Curve) var energy
export(Curve) var length

var day_night_timer_node
#onready var anim = $anim
var full_cycle = 1440.0


func update_shadow(val):
	var offset = day_night_timer_node.day_timestamp / full_cycle
	shadow_node.energy = energy.interpolate(offset)
	if shadow_node.energy == 0 and shadow_node.visible:
		 shadow_node.visible = false
	elif shadow_node.energy > 0 and not shadow_node.visible:
		shadow_node.visible = true
	if shadow_node.visible:
		rotation = -PI*2 * offset
		scale.y = length.interpolate(offset)
		
		
		if shadow_width != shadow_node.scale.y:
			shadow_node.scale.y = shadow_width
	
	
#	if anim.current_animation!="": #fix "Condition'!Playback.current.from'is true."
#		anim.seek(day_night_timer_node.day_timestamp / 1000.0)
	

func _ready() -> void:
	if get_tree().current_scene.has_node('DayNightCycle'):
		day_night_timer_node = get_tree().current_scene.get_node('DayNightCycle')
#		anim.current_animation = "dn_cycle"
		day_night_timer_node.connect('new_minute', self, 'update_shadow')
