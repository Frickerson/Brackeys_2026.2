extends Node2D

class_name HealthBar

@export var Health : ProgressBar = null
@export var MaxTrustChangePercent : float = 50.0
@export var LerpSpeed : float = 10.0
@export var DistrustChangeTime : float = 3.0

var CurrentHealth : float = 0.0
var MaxHealth : float = 0.0
var DistrustTimer : float = 0.0
var DistrustMultiplier : int = 1

func _process(delta: float) -> void:
	global_rotation = 0.0
	
	DistrustTimer += delta
	if DistrustTimer >= DistrustChangeTime:
		DistrustTimer -= DistrustChangeTime
		DistrustMultiplier *= -1
	
	_update_health_visual(delta)

func _initialize(max_health : int) -> void:
	MaxHealth = max_health
	CurrentHealth = max_health
	
func _update_health_visual(delta : float) -> void:
	var distrust_percent = 1 - Player.Trust / 100.0
	var change_percent = (MaxTrustChangePercent / 100.0) * distrust_percent
	var change_value = change_percent * MaxHealth * DistrustMultiplier
	
	var new_health = ((CurrentHealth - change_value) / MaxHealth) * 100.0
	Health.value = lerp(Health.value, new_health, LerpSpeed * delta)
	
func _update_health(damage : float) -> bool:
	CurrentHealth -= damage
	if CurrentHealth <= 0.0:
		return true
	
	return false
