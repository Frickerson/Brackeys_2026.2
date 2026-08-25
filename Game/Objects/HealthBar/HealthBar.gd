extends Node2D

class_name HealthBar

@export var Health : ProgressBar = null

var CurrentHealth : float = 0.0
var MaxHealth : float = 0.0

func _process(delta: float) -> void:
	global_rotation = 0.0

func _initialize(max_health : int) -> void:
	MaxHealth = max_health
	CurrentHealth = max_health
	
	_update_health_visual()
	
func _update_health_visual() -> void:
	Health.value = (CurrentHealth / MaxHealth) * 100.0
	
func _update_health(damage : float) -> bool:
	CurrentHealth -= damage
	if CurrentHealth <= 0.0:
		return true
	
	_update_health_visual()
	return false
