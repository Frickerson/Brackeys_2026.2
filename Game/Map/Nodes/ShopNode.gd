extends BaseNode

class_name ShopNode

@export var Title : String = "Shop"
@export var Descrition : String = "Many items lay before you. You can only choose one. Choose wisely!"
@export var Items : Array[ShopItem]

func _load_level() -> Level:
	var level : ShopLevel = super._load_level()
	level._set_title(Title)
	level._set_description(Descrition)
	level._set_items(Items)
	return level
