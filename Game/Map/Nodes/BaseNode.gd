extends Button
class_name BaseNode

@export var scene_to_load: PackedScene

func get_scene() -> PackedScene:
	scene_to_load.instantiate()
	return scene_to_load
	 
