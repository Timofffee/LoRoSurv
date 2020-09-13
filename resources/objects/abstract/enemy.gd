extends GameObject
class_name Enemy

# Используется для вражеских объектов

export(PackedScene) onready var res_scene

enum SEX {MALE, FEMALE, RND}
const MAX_FEAR = 10
const MIN_FEAR = 0

export(SEX) var sex = SEX.MALE setget set_sex
export(int, -1, 10) var fear = 10 setget set_fear


func  _init():
	randomize()


func set_sex(val):
	if val == SEX.RND:
		sex = randi() % 2
	else:
		sex = clamp(val, SEX.MALE, SEX.FEMALE)


func set_fear(val):
	if val == -1:
		fear = MAX_FEAR - (randi() % int(MAX_FEAR / 2))
	else:
		fear = val
 

func _ready():
	pass
