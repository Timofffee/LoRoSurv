extends Node

onready var world = $"World"
onready var ui = $"UI"
onready var day_night_cycle = $"DayNightCycle"

func _ready():
	day_night_cycle.connect("new_minute", ui.datetime, "set_minute")
	day_night_cycle.connect("new_hour", ui.datetime, "set_hour")
	day_night_cycle.connect("new_day", ui.datetime, "set_day")
	
	day_night_cycle.connect("new_minute", self, "update_ambient")


func update_ambient(val):
	
	var timestamp = day_night_cycle.get_day_timestamp()
	if $dn_cycle_anim.current_animation!="": #fix "Condition'!Playback.current.from'is true."
		$dn_cycle_anim.seek(timestamp / 1000.0)
	
