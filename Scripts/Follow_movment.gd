extends Node2D

func _ready():
	pass # Replace with function body.


func _on_Enemy_died(enemy):
	enemy.queue_free()
