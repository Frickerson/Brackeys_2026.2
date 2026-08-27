extends ShopItem

class_name Relic

@export var MultipliersChange : CharacterMultipliers

func _on_buy() -> void:
	Player._add_relic(self)
