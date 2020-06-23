extends TileMap

enum TileTyple {
	SURFACE = 4
}

var occupied_tiles = {}
var current_tower_id = 0


func select_tower(mouse_pos: Vector2) -> Tower:
	return occupied_tiles.get(world_to_map(mouse_pos), null)
	

func can_build_here(grid_pos: Vector2) -> bool:
	var cell = get_cell(grid_pos.x, grid_pos.y)
	return cell == TileTyple.SURFACE and not occupied_tiles.has(grid_pos)


func place_tower(mouse_pos: Vector2):
	var grid_pos = world_to_map(mouse_pos)

	if (can_build_here(grid_pos)):
		var new_tower = load("res://Scenes/tower.tscn").instance()
		new_tower.set_position(grid_pos * 16 + Vector2(8, 8))
		add_child(new_tower, true)
				
		occupied_tiles[grid_pos] = new_tower
		current_tower_id += 1


func move_selection(mouse_pos: Vector2):
	var grid_pos = world_to_map(mouse_pos)
	$Placement.position = grid_pos * 16
	
	if can_build_here(grid_pos):
		$Placement.change_color(true)
	else:
		$Placement.change_color(false)
