extends Camera2D

class_name Camera

@export var MaxCameraDistance : Vector2 = Vector2(200.0, 150.0)

var desired_offset : Vector2

func _process(delta: float) -> void:
	desired_offset = (get_global_mouse_position() - global_position) * 0.5
	desired_offset.x = clamp(desired_offset.x, -MaxCameraDistance.x, MaxCameraDistance.x)
	desired_offset.y = clamp(desired_offset.y, -MaxCameraDistance.y, MaxCameraDistance.y)
	
	global_position = global_position.lerp(get_parent().global_position + desired_offset, 0.5)
