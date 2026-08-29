extends Resource

class_name EventOption

@export var Title : String = "This is a title"
@export var TrustChange : float = 0.0
@export var MultipliersChange : CharacterMultipliers = null
@export var TooltipText : String = "This is a tooltip"
@export var NewWeaponList : Dictionary[String,PackedScene]

var ChosenWeapon : PackedScene = null
var ChosenWeaponName : String = ""

func _select_weapon() -> void:
	if NewWeaponList.is_empty():
		return
	
	var player_weapon : String = ""
	for key in NewWeaponList.keys():
		var value = NewWeaponList[key]
		if value.resource_path == Player.WeaponClass.resource_path:
			player_weapon = key
			break
		
	if player_weapon != "":
		NewWeaponList.erase(player_weapon)
	
	ChosenWeaponName = NewWeaponList.keys().pick_random()
	ChosenWeapon = NewWeaponList[ChosenWeaponName]

func _get_title() -> String:
	if ChosenWeapon:
		return str("Swap for the ", ChosenWeaponName)
	return Title
	
func _get_tooltip() -> String:
	if ChosenWeapon:
		return str("Swap your current weapon for the ", ChosenWeaponName)
	return TooltipText
