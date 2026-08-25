extends PanelContainer

class_name AmmoCounter

@export var Text : Label

var MaxAmmoCount : int = 0
var CurrentAmmoCount : int = 0

func _set_max_ammo_count(max_ammo_count : int) -> void:
	MaxAmmoCount = max_ammo_count
	_update_text()
	
func _set_current_ammo_count(current_ammo_count : int) -> void:
	CurrentAmmoCount = current_ammo_count
	_update_text()
	
func _update_text() -> void:
	Text.text = str(CurrentAmmoCount, "/", MaxAmmoCount)
