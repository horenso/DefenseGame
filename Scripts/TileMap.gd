extends TileMap

signal build_on_tilemap

var occupied_tiles = []

var current_tower_id = 0

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var mousePos = get_viewport().get_mouse_position()
		var loc = world_to_map(mousePos)
		var cell = get_cell(loc.x, loc.y)
		var name = tile_set.tile_get_name(cell)
		
		if (name == "surface" && not occupied_tiles.has(loc)):
			emit_signal("build_on_tilemap", loc, current_tower_id)
			current_tower_id += 1
			occupied_tiles.append(loc)
		print(occupied_tiles)