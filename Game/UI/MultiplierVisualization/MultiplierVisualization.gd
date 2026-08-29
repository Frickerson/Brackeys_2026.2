extends Control

class_name MultiplierVisualization

@export var Text : RichTextLabel

func _process(_delta: float) -> void:
	var multipliers = Player._get_multipliers()
	if not multipliers:
		return
	
	Text.text = multipliers._get_total_text()
	
