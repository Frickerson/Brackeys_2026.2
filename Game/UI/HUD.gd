extends CanvasLayer

@export var TrustMeterRef : TrustMeter
@export var AmmoCounterRef : AmmoCounter
@export var GoldCounterRef : GoldCounter
@export var WeaponSelectorRef : WeaponSelector

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	if PlayerRef == null:
		return
		
	TrustMeterRef._set_trust_value( PlayerRef.Trust )
	if PlayerRef.EquippedWeapon.UsesAmmo:
		AmmoCounterRef._set_max_ammo_count(PlayerRef._get_max_ammo())
		AmmoCounterRef._set_current_ammo_count(PlayerRef._get_current_ammo())
	else: 
		AmmoCounterRef.visible = false
	GoldCounterRef._set_gold_amount(Player.Gold)
	WeaponSelectorRef.get_sprite().texture = PlayerRef.EquippedWeapon.icon

func _process(_delta: float) -> void:
	if PlayerRef == null:
		return
		
	TrustMeterRef._set_trust_value( PlayerRef.Trust )
	if PlayerRef.EquippedWeapon.UsesAmmo: 
		AmmoCounterRef._set_current_ammo_count(PlayerRef._get_current_ammo())
	GoldCounterRef._set_gold_amount(Player.Gold)
