extends Level

class_name ShopLevel

@export var Title : Label
@export var Description : Label
@export var Items : Array[Button]
@export var ExitShopButton : Button

var ItemMap : Dictionary[Button, ShopItem]

func _ready() -> void:
	ExitShopButton.pressed.connect(_on_exit)

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
		ItemMap.set(current_item, wanted_item)
		
		if Player.Gold < wanted_item.Cost:
			current_item.disabled = true
			continue
			
		current_item.pressed.connect(_on_item_pressed.bind(wanted_item))
		
func _update_items() -> void:
	for item in ItemMap:
		var value = ItemMap.get(item)
		if Player.Gold < value.Cost:
			item.disabled = true

func _on_item_pressed(item : ShopItem):
	Player._update_gold(-item.Cost)
	ItemMap.find_key(item).disabled = true
	item._on_buy()
	_update_items()
		
func _on_exit():
	_on_win.emit()
