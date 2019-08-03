extends Node2D

# towers rotation, handled by the animation frames
var fake_rotation = 0

# sprite node, to change the animation frames
onready var sprite_node = get_node("done")
onready var collision_shape_node = get_node("range/CollisionShape2D")

# list of enemies that the tower sees
var list_of_enemies = []

# current enemy in gun sight
var selected_enemy = null

# angle between selected_enemy and tower
var angle_enemy = 0.0

func _ready():
	set_process(true)
	draw_circle(collision_shape_node.position, 20.0, Color(12))

func _process(delta):
	update_fake_rotation()

	if selected_enemy == null:
		if not list_of_enemies.empty():
			selected_enemy = list_of_enemies[0]
	elif not list_of_enemies.has(selected_enemy):
		selected_enemy = null
	else:
		angle_enemy = 90 + rad2deg(get_angle_to(selected_enemy.position))
		if angle_enemy < 0:
			angle_enemy = 360 + angle_enemy
		fake_rotation = int(round(angle_enemy / 22.5))

# update the towers rotation frames,
# fake_rotation is value between 0 and 15
func update_fake_rotation():
	if fake_rotation <= 8:
		sprite_node.set_frame(fake_rotation)
		sprite_node.set_flip_h(false)
	else:
		sprite_node.set_frame(16 - fake_rotation)
		sprite_node.set_flip_h(true)

func _on_range_area_entered(area):
	list_of_enemies.append(area)

func _on_range_area_exited(area):
	list_of_enemies.erase(area)
