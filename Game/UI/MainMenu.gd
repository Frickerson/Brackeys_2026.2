extends Control

@onready
var start_button = get_node("%StartButton")



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Levels/BasicLevel.tscn")
	pass # Replace with function body.
