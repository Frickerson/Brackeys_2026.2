extends Level

class_name EventLevel

@export var Title : Label
@export var Description : Label
@export var Option : Button

func _set_title(title : String) -> void:
	Title.text = title
	
func _set_description(description : String) -> void:
	Description.text = description
	
func _set_options(options : Array[EventOption]) -> void:
	for option in options:
		var new_option = _create_option()
		new_option.text = option.Title
		new_option.pressed.connect(_on_option_pressed.bind(option))
	
	Option.queue_free()

func _create_option() -> Button:
	var new_option = Option.duplicate()
	Option.get_parent().add_child(new_option)
	return new_option
	
func _on_option_pressed(option : EventOption):
	Player._update_trust(option.TrustChange)
	Player._add_multipliers(option.MultipliersChange)
	_on_win.emit()
	pass
