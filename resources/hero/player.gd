extends KinematicBody2D

const SPEED = 16 #px/sec
const RUN_SPEED = 32 

var dir = Vector2.ZERO
var last_dir = Vector2.RIGHT
var running = false

onready var anim_player = $anim


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	
	running = Input.is_action_pressed('run')
	
	dir = Vector2.ZERO
	if Input.is_action_pressed('move_up'):
		dir.y -= 1
	if Input.is_action_pressed('move_down'):
		dir.y += 1
	if Input.is_action_pressed('move_left'):
		dir.x -= 1
	if Input.is_action_pressed('move_right'):
		dir.x += 1
	
	if dir != Vector2.ZERO:
		last_dir = move_and_slide(dir.normalized() * (RUN_SPEED if running else SPEED)).normalized()
		
		
	
	update_anim()


func update_anim() -> void:
	var d = last_dir
	var prefix = "walk_" if dir != Vector2.ZERO else "idle_"
	var anim_dir = "right"
	
	if d.y < 0: #up
		anim_dir = "up"
	elif d.y > 0: #down
		anim_dir = "down"
	elif d.x > 0: #right
		anim_dir = "right"
	elif d.x < 0: #left
		anim_dir = "left"
	
	
	set_anim(prefix + anim_dir)


func set_anim(anim_name):
	anim_player.playback_speed = 0.75 if running else 0.3
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)

