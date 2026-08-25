extends Node2D

class_name Weapon

@export var AttackType: PackedScene
@export var AttackSpeed: float = 1.0:
	get:
		return AttackSpeed * AttackSpeedMultiplier
@export var MaxAmmo : int = 5
@export var AmmoPerShot : int = 1
@export var Damage : float = 5.0:
	get:
		return Damage * DamageMultiplier

var AttackTimer: float = 0.0
var Enabled: bool = false
var Ready: bool = false
var CurrentAmmo : int = 0
var UsesAmmo : bool = true
var AttackSpeedMultiplier : float = 1.0
var DamageMultiplier : float = 1.0

func _ready() -> void:
	Ready = true
	CurrentAmmo = MaxAmmo

func _process(delta: float) -> void:
	if Ready:
		if Enabled:
			_attack()
		return
	
	AttackTimer += AttackSpeed * delta
	if AttackTimer >= 1.0:
		Ready = true
		AttackTimer -= 1.0
		
func _toggle_attack(enable: bool) -> void:
	if enable == Enabled:
		return

	Enabled = enable
	if Enabled && Ready:
		_attack()
		
func _toggle_uses_ammo(use_ammo : bool) -> void:
	UsesAmmo = use_ammo
		
func _attack() -> void:
	var out_of_ammo = CurrentAmmo >= 0 && CurrentAmmo < AmmoPerShot
	if out_of_ammo :
		return
	
	_spawn_attack()
	
	if UsesAmmo && CurrentAmmo > 0:
		CurrentAmmo -= AmmoPerShot
	
	Ready = false
		
func _reload() -> void:
	CurrentAmmo = MaxAmmo
	
func _spawn_attack() -> void:
	var attack = _create_attack()
	attack.position = global_position
	attack.rotation = global_rotation
	
func _create_attack() -> Node:
	var attack = AttackType.instantiate() as Bullet
	get_tree().root.add_child(attack)
	attack.add_to_group(get_groups()[0])
	attack._initialize(Damage)
	
	return attack
	
func _update_multipliers(attack_speed_multiplier : float, damage_multiplier : float) -> void:
	AttackSpeedMultiplier = attack_speed_multiplier
	DamageMultiplier = damage_multiplier
