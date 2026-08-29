extends Level

class_name ShopLevel

@export var Title : Label
@export var Description : Label
@export var Items : Array[Button]
@export var ExitShopButton : Button
@export var GoldCounterRef : GoldCounter

var ItemMap : Dictionary[Button, ShopItem]

func _ready() -> void:
	ExitShopButton.pressed.connect(_on_exit)
	_update_gold()

func _set_title(title : String) -> void:
	Title.text = title
	
func _set_description(description : String) -> void:
	Description.text = description
	
func _set_items(items : Array[ShopItem]) -> void:
	if items.size() < Items.size():
		return
	
	items = _set_fake_items(items)
	
	items.shuffle()
	for index in Items.size():
		var current_item = Items[index]
		var wanted_item = items[index]
		current_item.text = str(wanted_item.Title, " ( Cost ", wanted_item.Cost, " )")
		current_item.tooltip_text = wanted_item.Tooltip
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
	var item_button : Button = ItemMap.find_key(item)
	var style_box = StyleBoxFlat.new()
	item_button.disabled = true
	if not item.IsFake:
		item._on_buy()
		style_box.bg_color = Color.FOREST_GREEN
		item_button.add_theme_stylebox_override("disabled", style_box)
	else:
		style_box.bg_color = Color.CRIMSON
		item_button.add_theme_stylebox_override("disabled", style_box)
		item_button.text = item.ScammedText
		item_button.tooltip_text = item.ScammedText
	_update_items()
	_update_gold()
		
func _on_exit():
	_on_win.emit()
	
func _update_gold() -> void:
	GoldCounterRef._set_gold_amount(Player.Gold)
	
func _set_fake_items(items : Array[ShopItem]) -> Array[ShopItem]:
	var distrust = (100.0 - Player.Trust) / 100.0
	var fake_item_amount = floori(4.0 * distrust)
	items.shuffle()
	
	for index in fake_item_amount:
		items[index].IsFake = true
		
	return items
