extends Node2D

class_name Tower

const AIMING_THRESHOLD: float = PI / 10
const bullet = preload("res://Scenes/bullet.tscn")

# core attributes
var level: int = 1
var price: int = 0
var detection_range: float = 50.0
var reaction_time: float = 1.0
var turning_speed: float = 10.0
var damage: int = 1
var cooldown_time: float = 0.5

# towers rotation, handled by the animation frames
var fake_rotation: int = 0
var aiming_at_enemy: bool = false

# list of enemies that the tower sees
var list_of_enemies = []

# current enemy in gun sight
var selected_enemy: Enemy = null


func _ready():
	var range_circle = CircleShape2D.new()
	range_circle.radius = detection_range
	$Range/CollisionShape2D.shape = range_circle
	$Range/RangeVisualizer.hide()
	$CoolDown.wait_time = cooldown_time


func _process(delta):
	select_enemy()
	if selected_enemy != null:
		point_at_enemy(delta)
		update_fake_rotation()
		fire_bullet()


func select_enemy():
	if selected_enemy == null:
		if not list_of_enemies.empty():
			selected_enemy = list_of_enemies[0]
	elif not list_of_enemies.has(selected_enemy):
		selected_enemy = null


func point_at_enemy(delta):
	var target_dir = (selected_enemy.global_position - global_position).normalized()
	var current_dir = Vector2(1, 0).rotated($Rotation.rotation)

	$Rotation.rotation = current_dir.linear_interpolate(target_dir, turning_speed * delta).angle()
	
	fake_rotation = int(round(rad2deg($Rotation.rotation + 0.5*PI) / 22.5))
	if fake_rotation < 0:
		fake_rotation = (fake_rotation % 16 + 16) % 16
	
	aiming_at_enemy = abs(current_dir.angle() - target_dir.angle()) <= AIMING_THRESHOLD

	$Top_Center.rotation = deg2rad(fake_rotation * 22.5)


# update the towers rotation frames,
# fake_rotation is value between 0 and 15
func update_fake_rotation():
	match fake_rotation:
		0, 1, 2:
			$Top.rotation = 0
			$Top.set_frame(fake_rotation)
			$Top.set_flip_h(false)
			$Top.set_flip_v(false)
		3:
			$Top.rotation = PI*0.5
			$Top.set_frame(1)
			$Top.set_flip_h(true)
			$Top.set_flip_v(false)
		4, 5, 6:
			$Top.rotation = PI*0.5
			$Top.set_frame(fake_rotation - 4)
			$Top.set_flip_h(false)
			$Top.set_flip_v(false)
		7:
			$Top.rotation = PI
			$Top.set_frame(1)
			$Top.set_flip_h(true)
			$Top.set_flip_v(false)
		8, 9, 10:
			$Top.rotation = 0
			$Top.set_frame(fake_rotation - 8)
			$Top.set_flip_h(true)
			$Top.set_flip_v(true)
		11:
			$Top.rotation = PI*0.5
			$Top.set_frame(1)
			$Top.set_flip_h(false)
			$Top.set_flip_v(true)
		12, 13, 14:
			$Top.rotation = PI*0.5
			$Top.set_frame(fake_rotation - 12)
			$Top.set_flip_h(true)
			$Top.set_flip_v(true)
		15:
			$Top.rotation = 0
			$Top.set_frame(1)
			$Top.set_flip_h(true)
			$Top.set_flip_v(false)


func select():
	$Range/RangeVisualizer.show()


func unselect():
	$Range/RangeVisualizer.hide()


func fire_bullet():
	if aiming_at_enemy and $CoolDown.is_stopped():
		var new_bullet = bullet.instance()
		new_bullet.give_target(selected_enemy)
		new_bullet.position = $Top_Center/Muzzle.global_position
		get_tree().get_root().add_child(new_bullet)
		$CoolDown.start()


func _on_range_area_entered(area):
	list_of_enemies.append(area)


func _on_range_area_exited(area):
	list_of_enemies.erase(area)
