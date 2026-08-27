extends PanelContainer

class_name GoldCounter

@export var Text : Label

func _set_gold_amount(amount : int) -> void:
	Text.text = str(amount)
