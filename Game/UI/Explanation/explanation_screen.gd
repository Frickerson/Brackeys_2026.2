extends Control

const NodeMap = preload("res://Game/Map/NodeMap.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(NodeMap)
	pass # Replace with function body.
