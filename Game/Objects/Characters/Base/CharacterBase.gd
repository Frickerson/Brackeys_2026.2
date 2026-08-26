extends CharacterBody2D

class_name CharacterBase

@export var TeamName : StringName = ""

@export_group("Movement")
@export var MoveSpeed: float = 150.0

@export_group("Bobbing")
@export var BobSpeed: float = 7.0
@export var BobDifference: float = 0.1

@export_group("Weapon")
@export var DefaultWeapon: PackedScene
@export var AttackLocation: Node2D

@export_group("Health")
@export var HealthBarRef : HealthBar
@export var MaxHealth : int = 100

@export_group("Multipliers")
@export var AttackSpeedMultiplier : float = 1.0
@export var DamageMultiplier : float = 1.0
@export var AttackRangeMultiplier : float = 1.0

var EquippedWeapon: Weapon = null
var IsMoving: bool = false
var ShouldScaleUp: bool = false
var BobTime: float = 0.5

signal OnDied

func _ready() -> void:	
	if DefaultWeapon != null:
		_equip_weapon(DefaultWeapon)
		
	HealthBarRef._initialize(MaxHealth)
	
func _take_damage(damage : float) -> void:
	if HealthBarRef._update_health(damage):
		OnDied.emit()
		$DeathParticles.emitting = true
		$DeathParticles.finished.connect(delete_after_particles)


func delete_after_particles():
	queue_free()
	
func _process(delta: float) -> void:
	if IsMoving:
		_update_bobbing(delta)
	else:
		BobTime = lerp(BobTime, 0.5, delta * BobSpeed)
		var new_scale = lerp(1.0 - BobDifference, 1.0 + BobDifference, BobTime)
		scale = Vector2(new_scale, new_scale)
		
func _update_bobbing(delta: float) -> void:
	if ShouldScaleUp:
		BobTime += delta * BobSpeed
		
		if BobTime >= 1.0:
			ShouldScaleUp = false
			BobTime = 1.0
			
	else:
		BobTime -= delta * BobSpeed
		
		if BobTime <= 0.0:
			ShouldScaleUp = true
			BobTime = 0.0
	
	var new_scale = lerp(1.0 - BobDifference, 1.0 + BobDifference, BobTime)
	scale = Vector2(new_scale, new_scale)
	
func _equip_weapon(weapon_class : PackedScene) -> void:
	EquippedWeapon = weapon_class.instantiate()
	AttackLocation.add_child(EquippedWeapon)
	EquippedWeapon.add_to_group(TeamName)
	EquippedWeapon._update_multipliers(AttackSpeedMultiplier, DamageMultiplier, AttackRangeMultiplier)
	
func _update_multipliers(multiplier : float) -> void:
	AttackSpeedMultiplier = multiplier
	DamageMultiplier = multiplier
	AttackRangeMultiplier = multiplier
	
	if EquippedWeapon:
		EquippedWeapon._update_multipliers(AttackSpeedMultiplier, DamageMultiplier, AttackRangeMultiplier)
