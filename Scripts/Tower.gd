extends Node2D

# core attributes
var UPGRADE_STATE = 0
var PRICE_TO_BUY = 0
var RANGE = 30
var REACTION_TIME = 1
var SHOOTING_SPEED = 1
var TURNING_SPEED = 12
var DAMAGE = 1

var is_selected = false

# towers rotation, handled by the animation frames
var fake_rotation = 0

# sprite node, to change the animation frames
onready var Top = get_node("Top")
onready var collision_shape_node = get_node("range/CollisionShape2D")
onready var top_center_node = get_node("Top_Center")

# list of enemies that the tower sees
var list_of_enemies = []

# current enemy in gun sight
var selected_enemy = null

# angle between selected_enemy and tower
var angle_enemy = 0.0

var range_circle = CircleShape2D.new()

func _ready():
	range_circle.radius = RANGE
	$Range/CollisionShape2D.shape = range_circle

func _process(delta):
	select_enemy()
	point_at_enemy(delta)
	update_fake_rotation()
	get_node("Label").text = str(fake_rotation)

func select_enemy():
	if selected_enemy == null:
		if not list_of_enemies.empty():
			selected_enemy = list_of_enemies[0]
	elif not list_of_enemies.has(selected_enemy):
		selected_enemy = null

func point_at_enemy(delta):
	if selected_enemy == null:
		return

	angle_enemy = 90 + rad2deg(get_angle_to(selected_enemy.position))
	var target_dir = (selected_enemy.global_position - global_position).normalized()
	var current_dir = Vector2(1, 0).rotated($Rotation.global_rotation)

	$Rotation.global_rotation = current_dir.linear_interpolate(target_dir, TURNING_SPEED * delta).angle()
		
	fake_rotation = int(round(rad2deg($Rotation.rotation + 0.5*PI) / 22.5))
	if fake_rotation < 0:
		fake_rotation = (fake_rotation % 16 + 16) % 16
	top_center_node.rotation = deg2rad(fake_rotation * 22.5)
		
# update the towers rotation frames,
# fake_rotation is value between 0 and 15
func update_fake_rotation():
	match fake_rotation:
		0, 1, 2:
			Top.rotation = 0
			Top.set_frame(fake_rotation)
			Top.set_flip_h(false)
			Top.set_flip_v(false)
		3:
			Top.rotation = PI*0.5
			Top.set_frame(1)
			Top.set_flip_h(true)
			Top.set_flip_v(false)
		4, 5, 6:
			Top.rotation = PI*0.5
			Top.set_frame(fake_rotation - 4)
			Top.set_flip_h(false)
			Top.set_flip_v(false)
		7:
			Top.rotation = PI
			Top.set_frame(1)
			Top.set_flip_h(true)
			Top.set_flip_v(false)
		8, 9, 10:
			Top.rotation = 0
			Top.set_frame(fake_rotation - 8)
			Top.set_flip_h(true)
			Top.set_flip_v(true)
		11:
			Top.rotation = PI*0.5
			Top.set_frame(1)
			Top.set_flip_h(false)
			Top.set_flip_v(true)
		12, 13, 14:
			Top.rotation = PI*0.5
			Top.set_frame(fake_rotation - 12)
			Top.set_flip_h(true)
			Top.set_flip_v(true)
		15:
			Top.rotation = 0
			Top.set_frame(1)
			Top.set_flip_h(true)
			Top.set_flip_v(false)

func _on_range_area_entered(area):
	list_of_enemies.append(area)

func _on_range_area_exited(area):
	list_of_enemies.erase(area)
