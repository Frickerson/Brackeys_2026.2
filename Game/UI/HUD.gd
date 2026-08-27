extends CanvasLayer

@export var TrustMeterRef : TrustMeter
@export var AmmoCounterRef : AmmoCounter
@export var GoldCounterRef : GoldCounter

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	if PlayerRef == null:
		return
		
	TrustMeterRef._set_trust_value( PlayerRef.Trust )
	AmmoCounterRef._set_max_ammo_count(PlayerRef._get_max_ammo())
	AmmoCounterRef._set_current_ammo_count(PlayerRef._get_current_ammo())
	GoldCounterRef._set_gold_amount(Player.Gold)

func _process(_delta: float) -> void:
	if PlayerRef == null:
		return
		
	TrustMeterRef._set_trust_value( PlayerRef.Trust )
	AmmoCounterRef._set_current_ammo_count(PlayerRef._get_current_ammo())
	GoldCounterRef._set_gold_amount(Player.Gold)
