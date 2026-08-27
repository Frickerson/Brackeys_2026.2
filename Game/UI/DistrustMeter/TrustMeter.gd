extends PanelContainer

class_name TrustMeter

@export var Meter : ProgressBar

func _set_trust_value (trust_value : float) -> void:
	Meter.value = trust_value
