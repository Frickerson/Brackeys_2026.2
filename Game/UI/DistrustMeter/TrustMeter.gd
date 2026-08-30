extends PanelContainer

class_name TrustMeter

@export var Meter : ProgressBar

func _set_trust_value (trust_value : float) -> void:
	Meter.value = trust_value
	$VBoxContainer/Amount.text = str(trust_value).pad_decimals(0)

func _ready() -> void:
	_set_trust_value(Player.Trust)

func _process(delta: float) -> void:
	_set_trust_value(Player.Trust)
