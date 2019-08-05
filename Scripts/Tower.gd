extends Node2D

# core attributes
var UPGRADE_STATE = 0
var PRICE_TO_BUY = 0
var RANGE = 10
var REACTION_TIME = 1
var SHOOTING_SPEED = 1
var DAMAGE = 1

# towers rotation, handled by the animation frames
var fake_rotation = 0

# sprite node, to change the animation frames
onready var top = get_node("top")
onready var collision_shape_node = get_node("range/CollisionShape2D")

# list of enemies that the tower sees
var list_of_enemies = []

# current enemy in gun sight
var selected_enemy = null

# angle between selected_enemy and tower
var angle_enemy = 0.0

func _ready():
	set_process(true)

func _process(delta):
	select_enemy()
	if Input.is_action_just_released("Y"):
		fake_rotation = (fake_rotation + 1) % 16
	update_fake_rotation()
	get_node("Label").text = str(fake_rotation)

func select_enemy():
	if selected_enemy == null:
		if not list_of_enemies.empty():
			selected_enemy = list_of_enemies[0]
	elif not list_of_enemies.has(selected_enemy):
		selected_enemy = null
	else:
		angle_enemy = 90 + rad2deg(get_angle_to(selected_enemy.position))
		if angle_enemy < 0:
			angle_enemy = 360 + angle_enemy
		fake_rotation = int(floor(angle_enemy / 22.5))

# update the towers rotation frames,
# fake_rotation is value between 0 and 15
func update_fake_rotation():
	match fake_rotation:
		0, 1, 2:
			top.rotation = 0
			top.set_frame(fake_rotation)
			top.set_flip_h(false)
			top.set_flip_v(false)
		3:
			top.rotation = PI*0.5
			top.set_frame(1)
			top.set_flip_h(true)
			top.set_flip_v(false)
		4, 5, 6:
			top.rotation = PI*0.5
			top.set_frame(fake_rotation - 4)
			top.set_flip_h(false)
			top.set_flip_v(false)
		7:
			top.rotation = PI
			top.set_frame(1)
			top.set_flip_h(true)
			top.set_flip_v(false)
		8, 9, 10:
			top.rotation = 0
			top.set_frame(fake_rotation - 8)
			top.set_flip_h(true)
			top.set_flip_v(true)
		11:
			top.rotation = PI*0.5
			top.set_frame(1)
			top.set_flip_h(false)
			top.set_flip_v(true)
		12, 13, 14:
			top.rotation = PI*0.5
			top.set_frame(fake_rotation - 12)
			top.set_flip_h(true)
			top.set_flip_v(true)
		15:
			top.rotation = 0
			top.set_frame(1)
			top.set_flip_h(true)
			top.set_flip_v(false)

func _on_range_area_entered(area):
	list_of_enemies.append(area)

func _on_range_area_exited(area):
	list_of_enemies.erase(area)
