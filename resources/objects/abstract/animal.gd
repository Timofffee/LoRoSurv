extends Enemy
class_name Animal

enum ACTIONS {SLEEP, EAT, DRINK, GAME, RELAX, WALK, REPR, COMM, BATTLE, RND}

export(int) var thirst = 50
export(int) var speed = 100

var dir = 0

var schedule

func update_direction() -> void:
	#dir = GDHelpers.rnd_sign()
	if dir:
		$"Sprite".flip_h = dir < 0


func move() -> void:
	move_and_slide(dir * speed)


func play_anim(name: String) -> void:
	$"Anim".play(name)


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		assert(res_scene, "%s :: res_scene == null" % name)
		visible == false
		if res_scene:
			if parent:
				var res = res_scene.instance()
				res.position = position
				parent.add_child(res)


func drink():
	pass


func eat():
	pass


func _ready():
	add_to_group("animals")
	
