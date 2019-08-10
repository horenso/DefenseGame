extends Node2D

func _ready():
	$ProgressBar.value = 100
	$ProgressBar.visible = false

func _process(delta):
	global_rotation = 0

func _update_healthbar(health):
	print("got signal")
	$ProgressBar.visible = true
	$ProgressBar.value = health
