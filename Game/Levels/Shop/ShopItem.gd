extends Resource

class_name ShopItem

@export var Title : String = "This is a title"
@export var Cost : int = 10
@export var Tooltip : String = "This is a tooltip"
@export var ScammedText : String = "You got scammed"

var IsFake : bool = false

func _on_buy() -> void:
	pass
	
func _get_tooltip_text() -> String:
	return Tooltip
