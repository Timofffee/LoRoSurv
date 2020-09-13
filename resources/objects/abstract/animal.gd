extends Enemy
class_name Animal

enum ACTIONS {SLEEP, EAT, DRINK, GAME, RELAX, WALK, REPR, COMM, BATTLE, RND}


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		assert(res_scene, "%s :: res_scene == null" % name)
		visible == false
		if res_scene:
			if world:
				var res = res_scene.instance()
				res.position = position
				world.add_child(res)


func _ready():
	pass # Replace with function body.
