extends Node2D

var radius: float

func _ready():
	radius = int(get_parent().get_parent().detection_range)

func _draw():
	draw_circle(position, radius, Color(0.0, 0.0, 0.0, 0.3))
