extends Control

class_name PauseMenu

func _on_continue_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_back_to_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Game/UI/MainMenu.tscn")

func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
		
	if !event.is_action("ui_cancel"):
		return
	
	if get_tree().paused || visible:
		get_tree().paused = false
		visible = false
		return
	
	get_tree().paused = true
	visible = true
