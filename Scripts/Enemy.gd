extends Node2D

signal died
signal health_changed

# core attributes
var SPEED = 100
var VALUE = 0
var LIFE = 100
var CAUSING_DAMAGE = 10

onready var animation_player = get_node("Rocketship/AnimationPlayer")
var has_moved = false

func _ready():
	set_process(true)
	animation_player.play("Idle")
	
func _process(delta):
	test_healthbar()
	test_movement(delta)
	
func lose_health(health):
	LIFE -= health
	print(LIFE)
	if LIFE > 0:
		emit_signal("health_changed", LIFE)
	else:
		emit_signal("died", self)

func test_healthbar():
	if Input.is_action_just_released("Y"):
		lose_health(10)
		print("LIFE DEDUCTED")
		
func test_movement(delta):
	has_moved = false
	if Input.is_action_pressed("ui_left"):
		animation_player.play("fire")
		global_translate(Vector2(-1, 0) * delta * SPEED)
		set_global_rotation_degrees(270)
		has_moved = true
	elif Input.is_action_pressed("ui_right"):
		animation_player.play("fire")
		global_translate(Vector2(1, 0) * delta * SPEED)
		set_global_rotation_degrees(90)
		has_moved = true
	if Input.is_action_pressed("ui_down"):
		animation_player.play("fire")
		global_translate(Vector2(0, 1) * delta * SPEED)
		set_global_rotation_degrees(180)
		has_moved = true
	if Input.is_action_pressed("ui_up"):
		animation_player.play("fire")
		global_translate(Vector2(0, -1) * delta * SPEED)
		set_global_rotation_degrees(0)
		has_moved = true
	
	if not has_moved:
		animation_player.play("Idle")
