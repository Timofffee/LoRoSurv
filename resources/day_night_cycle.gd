extends Timer
class_name DayNightCycle

signal new_day(val)
signal new_hour(val)
signal new_minute(val)
signal new_quarter(val)

enum QUATERS{NIGHT, MORNING, DAY, EVENING}

var  beginning_quater = {
		QUATERS.MORNING: 6,
		QUATERS.DAY: 12,
		QUATERS.EVENING: 18,
		QUATERS.NIGHT: 24
}


var day = 0 setget set_day
var hour = 0 setget set_hour
var minute = 0 setget set_minute
var quarter = QUATERS.NIGHT setget set_quater

var timestamp = 0
var day_timestamp = 0

func set_quater(val, emitter=null):
	quarter = val
	if emitter != self:
		set_hour(beginning_quater[quarter], self)
	emit_signal("new_quarter", val)


func set_day(val):
	day = val
	emit_signal("new_day", day)


func set_hour(val, emitter = null):
	if val % beginning_quater[QUATERS.NIGHT] == 0:
		hour = 0
		quarter = QUATERS.NIGHT
		emit_signal("new_hour", hour)
		if emitter != self:
			self.day += 1
	else:
		hour = val
		if emitter != self:
			if hour == beginning_quater[QUATERS.MORNING]:
				set_quater(QUATERS.MORNING, self)
			elif hour == beginning_quater[QUATERS.DAY]:
				set_quater(QUATERS.DAY, self)
			elif hour == beginning_quater[QUATERS.EVENING]:
				set_quater(QUATERS.EVENING, self)
		emit_signal("new_hour", hour)


func set_minute(val):
	if val % 60 == 0:
		minute = 0
		emit_signal("new_minute", minute)
		self.hour += 1
	else:
		minute = val
		emit_signal("new_minute", minute)
	
	update_timestamp()
	update_day_timestamp()


func update_timestamp():
	timestamp = minute + ((hour + day * 24) * 60)


func update_day_timestamp():
	day_timestamp = minute + (hour * 60)


func _on_DayNightCycle_timeout():
	self.minute += 1


func _ready():
	pass
