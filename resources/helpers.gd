extends Reference
class_name GDHelpers


static func rnd_sign():
	if randi() % 2 == 0:
		return 1
	return -1
