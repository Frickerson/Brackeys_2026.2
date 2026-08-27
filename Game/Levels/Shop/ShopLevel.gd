extends Level

class_name ShopLevel

@export var Title : Label
@export var Description : Label
@export var Items : Array[Button]

func _set_title(title : String) -> void:
	Title.text = title
	
func _set_description(description : String) -> void:
	Description.text = description
	
func _set_items(items : Array[ShopItem]) -> void:
	if items.size() < Items.size():
		return
	
	items.shuffle()
	for index in Items.size():
		var current_item = Items[index]
		var wanted_item = items[index]
		current_item.text = str(wanted_item.Title, " ( Cost ", wanted_item.Cost, " )")
		
		if Player.Gold < wanted_item.Cost:
			current_item.disabled = true
			continue
			
		current_item.pressed.connect(_on_item_pressed.bind(wanted_item))

func _on_item_pressed(item : ShopItem):
	Player._update_trust(item.TrustChange)
	if item.MultipliersChange:
		Player._add_multipliers(item.MultipliersChange)
	_on_win.emit()
	pass
