extends CanvasLayer

@export var DistrustMeterRef : DistrustMeter
@export var AmmoCounterRef : AmmoCounter

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	if PlayerRef == null:
		return
		
	DistrustMeterRef._set_distrust_value( PlayerRef.Distrust )
	AmmoCounterRef._set_max_ammo_count(PlayerRef._get_max_ammo())
	AmmoCounterRef._set_current_ammo_count(PlayerRef._get_current_ammo())

func _process(_delta: float) -> void:
	if PlayerRef == null:
		return
		
	DistrustMeterRef._set_distrust_value( PlayerRef.Distrust )
	AmmoCounterRef._set_current_ammo_count(PlayerRef._get_current_ammo())
