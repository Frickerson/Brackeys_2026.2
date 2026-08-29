extends ShopItem

class_name Relic

@export var MultipliersChange : CharacterMultipliers

func _on_buy() -> void:
	Player._add_relic(self)
	
func _get_tooltip_text() -> String:
	var result = super._get_tooltip_text()
	if MultipliersChange:
		result += str("\n", MultipliersChange._get_additive_text())
	return result
