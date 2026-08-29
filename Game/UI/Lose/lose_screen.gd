extends Control

const MainMenu: PackedScene = preload("res://Game/UI/MainMenu.tscn")

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_packed(MainMenu)
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
