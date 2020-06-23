extends Node2D

class_name Enemy

signal died
signal health_changed

# core attributes
var SPEED = 100
var VALUE = 0
var HEALTH = 100
var CAUSING_DAMAGE = 10

var has_moved = false

func _ready():
	set_process(true)
	$Rocketship/AnimationPlayer.play("Idle")
	
func _process(delta):
	test_movement(delta)
	
func lose_health(damage):
	HEALTH -= damage
	if HEALTH > 0:
		emit_signal("health_changed", HEALTH)
	else:
		emit_signal("died", self)
		
func test_movement(delta):
	has_moved = false
	if Input.is_action_pressed("ui_left"):
		$Rocketship/AnimationPlayer.play("fire")
		global_translate(Vector2(-1, 0) * delta * SPEED)
		set_global_rotation_degrees(270)
		has_moved = true
	elif Input.is_action_pressed("ui_right"):
		$Rocketship/AnimationPlayer.play("fire")
		global_translate(Vector2(1, 0) * delta * SPEED)
		set_global_rotation_degrees(90)
		has_moved = true
	if Input.is_action_pressed("ui_down"):
		$Rocketship/AnimationPlayer.play("fire")
		global_translate(Vector2(0, 1) * delta * SPEED)
		set_global_rotation_degrees(180)
		has_moved = true
	if Input.is_action_pressed("ui_up"):
		$Rocketship/AnimationPlayer.play("fire")
		global_translate(Vector2(0, -1) * delta * SPEED)
		set_global_rotation_degrees(0)
		has_moved = true
	
	if not has_moved:
		$Rocketship/AnimationPlayer.play("Idle")
