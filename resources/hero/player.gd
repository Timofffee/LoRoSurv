extends KinematicBody2D

const SPEED = 20 #px/sec
const RUN_SPEED = 30 

var dir = Vector2.ZERO
var last_dir = Vector2.RIGHT
var running = false
export var shooting = false

onready var anim_player = $anim

var trace_inst = preload('res://resources/trace.tscn')

var joys = []

func _ready() -> void:
	joys = Input.get_connected_joypads()
	Input.connect('joy_connection_changed', self, '_change_joy_state')


func _process(delta: float) -> void:
	if shooting:
		return
	
	running = Input.is_action_pressed('run')
	
	dir = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	if abs(dir.x) < 0.1: dir.x = 0
	if abs(dir.y) < 0.1: dir.y = 0
	
	if dir == Vector2.ZERO:
		dir = Vector2.ZERO
		if Input.is_action_pressed('move_up'):    dir.y -= 1
		if Input.is_action_pressed('move_down'):  dir.y += 1
		if Input.is_action_pressed('move_left'):  dir.x -= 1
		if Input.is_action_pressed('move_right'): dir.x += 1
	
	if dir != Vector2.ZERO:
		last_dir = dir
		move_and_slide(dir.normalized() * (RUN_SPEED if running else SPEED))
	
	update_anim()


func update_anim() -> void:
	var d = last_dir
	var prefix = "walk_" if dir != Vector2.ZERO else "idle_"
	var anim_dir = "rd"
	
	if d.y >= 0 and d.x >= 0:
		anim_dir = "rd"
	elif d.y >= 0 and d.x <= 0:
		anim_dir = "ld"
	elif d.y <= 0 and d.x >= 0:
		anim_dir = "ru"
	elif d.y <= 0 and d.x <= 0:
		anim_dir = "lu"
	
	
	set_anim(prefix + anim_dir)


func set_anim(anim_name):
	anim_player.playback_speed = 0.7 if running else 0.5
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)

func instance_trace() -> void:
	var t = trace_inst.instance()
	get_parent().add_child(t)
	t.global_position = $trace_pos.global_position
	t.global_position.x = int(t.global_position.x)
	t.global_position.y = int(t.global_position.y)


func _change_joy_state(id, connected) -> void:
	print(id, connected)
	if connected:
		if not joys.has(id):
			joys.append(id)
	else:
		if joys.has(id):
			joys.remove(id)
