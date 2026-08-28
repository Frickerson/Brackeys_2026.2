extends Control

class_name BaseNode

@export var scene_to_load: PackedScene
@export var ChildNodes : Array[BaseNode]

var LoadedLevel : Level = null

func get_button() -> TextureButton:
	return $Image

func _draw() -> void:
	var start_position = Vector2.ZERO + _get_local_center_top()
	
	for child in ChildNodes:
		var end_position = child.global_position - global_position + child._get_local_center_bottom()
		draw_line(start_position, end_position, Color.BLACK, 5.0, true)

func _get_loaded_level() -> Level:
	if LoadedLevel:
		return LoadedLevel
	
	return _load_level()

func _load_level() -> Level:
	LoadedLevel = scene_to_load.instantiate() as Level
	return LoadedLevel

func _toggle_children(enable : bool, callable : Callable) ->void:
	for child in ChildNodes:
		child.disabled = !enable
		if enable:
			child.pressed.connect(callable)
		else:
			child.pressed.disconnect(callable)
			
func _get_local_center_top() -> Vector2:
	return Vector2($Image.size.x / 2.0, 0.0)
	
func _get_local_center_bottom() -> Vector2:
	return Vector2($Image.size.x / 2.0, $Image.size.y)

func set_enabled():
	$Image.disabled=false
	%AnimationPlayer.play("Active")

func set_cleared() -> void:
	$Image.disabled = true
	$Image/TextureRect.visible = true
	%AnimationPlayer.stop()
