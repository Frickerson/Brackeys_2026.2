extends Button
class_name BaseNode
@export var scene_to_load: PackedScene
@export var ChildNodes : Array[BaseNode]

func _draw() -> void:
	var start_position = Vector2.ZERO + _get_local_center_top()
	
	for child in ChildNodes:
		var end_position = child.global_position - global_position + child._get_local_center_bottom()
		draw_line(start_position, end_position, Color.BLACK, 5.0, true)

func get_scene() -> PackedScene:
	scene_to_load.instantiate()
	return scene_to_load

func _toggle_children(enable : bool, callable : Callable) ->void:
	for child in ChildNodes:
		child.disabled = !enable
		if enable:
			child.pressed.connect(callable)
		else:
			child.pressed.disconnect(callable)
			
func _get_local_center_top() -> Vector2:
	return Vector2(size.x / 2.0, 0.0)
	
func _get_local_center_bottom() -> Vector2:
	return Vector2(size.x / 2.0, size.y)
