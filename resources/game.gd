extends Node

onready var world = $"World"
onready var ui = $"UI"
onready var day_night_cycle = $"DayNightCycle"

func _ready():
	day_night_cycle.connect("new_minute", ui.datetime, "set_minute")
	day_night_cycle.connect("new_hour", ui.datetime, "set_hour")
	day_night_cycle.connect("new_day", ui.datetime, "set_day")
