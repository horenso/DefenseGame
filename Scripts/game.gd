extends Node2D

class_name Game

const TOWER_1 = preload('res://Scenes/tower.tscn')
const TOWER_2 = preload('res://Scenes/tower.tscn')

enum Mode {
	SELECTION,
	PLACEMENT,
}

var game_mode: int = Mode.SELECTION
var selected_tower: Tower = null


func _unhandled_input(event):
	var mouse_pos = get_viewport().get_mouse_position()
	
	match game_mode:
		Mode.SELECTION:
			if event.is_action_pressed("click"):
				if selected_tower != null:
					selected_tower.unselect()
				selected_tower = $TileMap.select_tower(mouse_pos)
				if selected_tower != null:
					selected_tower.select()
			if event.is_action_pressed("ui_cancel"):
				if selected_tower != null:
					selected_tower.unselect()
		Mode.PLACEMENT:
			$TileMap.move_selection(mouse_pos)
			if event.is_action_pressed("click"):
				$TileMap.place_tower(mouse_pos)
				change_game_mode(Mode.SELECTION)
			if event.is_action_pressed("ui_cancel"):
				change_game_mode(Mode.SELECTION)


func change_game_mode(new_mode: int):
	if new_mode == Mode.SELECTION:
		$TileMap/Placement.hide()
		$TileMap/Placement.position = Vector2(0.0, 0.0)
	if new_mode == Mode.PLACEMENT:
		$TileMap/Placement.show()
	game_mode = new_mode


func _on_Enemy_died(enemy):
	enemy.queue_free()


func _on_tower_1():
	change_game_mode(Mode.PLACEMENT)


func _on_tower_2():
	change_game_mode(Mode.PLACEMENT)


func _on_tower_3():
	change_game_mode(Mode.PLACEMENT)
