extends PanelContainer

class_name DistrustMeter

@export var Meter : ProgressBar

func _set_distrust_value (distrust_value : float) -> void:
	Meter.value = distrust_value
