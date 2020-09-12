extends HBoxContainer

onready var minute = $"Minute"
onready var hour = $"Hour"
onready var day = $"Day"

func set_day(val):
	day.text = str(val)


func set_minute(val):
	minute.text = str(val).pad_zeros(2)


func set_hour(val):
	hour.text = str(val).pad_zeros(2)


func _ready():
	pass # Replace with function body.

