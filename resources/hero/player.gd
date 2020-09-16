extends KinematicBody2D

const SPEED = 16 #px/sec
const RUN_SPEED = 32
const SPEED_DEADZONE = 0.1

var dir = Vector2.ZERO
var _dir = Vector2.ZERO

var last_dir = Vector2.RIGHT
var running = false
enum STATE {IDLE, WALK, RUN, DO, SIT, MINE, SHOOT}
export(STATE) var state = 0

onready var anim_player = $anim

var trace_inst = preload('res://resources/trace.tscn')

var joys = []

func _ready() -> void:
	joys = Input.get_connected_joypads()
	Input.connect('joy_connection_changed', self, '_change_joy_state')
	
	if get_tree().current_scene.has_node('InGameCamera'):
		get_tree().current_scene.get_node('InGameCamera').target = self


func _process(delta: float) -> void:
	if state == STATE.IDLE:
		if Input.is_action_just_pressed('sit'):
			anim_player.play('sit_' + ('ld' if last_dir.x < 0 else 'rd'))
			return
		if Input.is_action_just_pressed('eat'):
			anim_player.play('eating_' + ('ld' if last_dir.x < 0 else 'rd'))
			return
	if state == STATE.SIT:
		if Input.is_action_just_pressed('sit'):
			anim_player.play('stand_' + ('ld' if last_dir.x < 0 else 'rd'))
			return
	
	if not state in [STATE.IDLE, STATE.WALK, STATE.RUN]:
		return
	
	update_velocity(delta)
	update_anim()
	update()


func update_velocity(delta: float) -> void:
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
	
	_dir = _dir.linear_interpolate(dir.normalized() * (RUN_SPEED if running else SPEED), 1.0)
	
	if _dir.length() > SPEED_DEADZONE:
		last_dir = _dir
		# fucken bug?
		_dir = move_and_slide(_dir)
	else:
		_dir = Vector2.ZERO
	
	if _dir.length() > 0:
		if _dir.length() > SPEED + SPEED_DEADZONE:
			state = STATE.RUN
		else:
			state = STATE.WALK
	else:
		state = STATE.IDLE


func update_anim() -> void:
	var d = last_dir
	var prefix = ""
	match state:
		STATE.WALK:
			prefix = "walk_"
		STATE.RUN:
			prefix = "run_"
		_:
			prefix = "idle_"
	
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


func _draw() -> void:
	draw_line(Vector2.ZERO, _dir, Color(0.8, 0.1, 0.5))
