extends CanvasLayer

@export var DistrustMeterRef : DistrustMeter

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	DistrustMeterRef._set_distrust_value( PlayerRef.Distrust )

func _process(delta: float) -> void:
	DistrustMeterRef._set_distrust_value( PlayerRef.Distrust )
	
