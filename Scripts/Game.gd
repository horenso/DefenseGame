extends Node2D

func _build_on_tilemap(pos, id):
	var scene = load("res://Scenes/Tower.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name(str(id))
	add_child(scene_instance, true)
	var n = get_node(str(id)).set_position(pos * 16 + Vector2(8, 8))
	$TypeLable.text = str(id)

func _on_Enemy_died(enemy):
	enemy.queue_free()
