extends Node2D

func _ready():
	$ProgressBar.visible = false

func _process(delta):
	global_rotation = 0

func _update_healthbar(health):
	$ProgressBar.visible = true
	$ProgressBar.value = health
