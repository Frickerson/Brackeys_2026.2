extends Node2D

class_name HealthBar

@export var Health : ProgressBar = null
@export var MaxTrustChangePercent : float = 100.0
@export var LerpSpeed : float = 10.0
@export var DistrustChangeTime : float = 3.0

var CurrentHealth : float = 0.0
var MaxHealth : float = 0.0
var DistrustMultiplier : float = 0.0
var PreviousTrust : float = 0.0

func _ready() -> void:
	_randomize_trust_multiplier()
	PreviousTrust = Player.Trust

func _process(delta: float) -> void:
	global_rotation = 0.0
	
	if Player.Trust != PreviousTrust:
		PreviousTrust = Player.Trust
		_randomize_trust_multiplier()
	
	_update_health_visual(delta)

func _initialize(max_health : int) -> void:
	MaxHealth = max_health
	CurrentHealth = max_health
	
func _update_health_visual(delta : float) -> void:
	var distrust_percent = 1.0 - (Player.Trust / 100.0)
	var change_percent = (MaxTrustChangePercent / 100.0) * distrust_percent
	var change_value = change_percent * MaxHealth * DistrustMultiplier
	
	var new_health = maxf(CurrentHealth - change_value, 0.0)
	var new_health_percent = (new_health / MaxHealth) * 100.0
	Health.value = lerp(Health.value, new_health_percent, LerpSpeed * delta)
	
func _update_health(damage : float) -> bool:
	CurrentHealth = clamp(CurrentHealth - damage, 0.0, MaxHealth)
	if CurrentHealth <= 0.0:
		return true
	
	return false
	
func _randomize_trust_multiplier() -> void:
	DistrustMultiplier = randf_range(-1.0, 1.0)
