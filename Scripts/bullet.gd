extends Area2D

class_name Bullet

var enemy: Enemy = null
var speed: float = 75.0
var damage: int = 3
var current_direction: Vector2 = Vector2(0.0, 0.0)


func give_target(new_enemy: Enemy):
	self.enemy = new_enemy


func _process(delta):
	if enemy != null and is_instance_valid(enemy):
		current_direction = (enemy.position - position).normalized()
	translate(current_direction * speed * delta)


func _area_entered(area: Enemy):
	area.lose_health(damage)
	queue_free()
