extends Sprite

export var red: Color
export var green: Color

func change_color(current_color_green: bool):
	if current_color_green:
		material.set_shader_param('current_color', green)
	else:
		material.set_shader_param('current_color', red)
