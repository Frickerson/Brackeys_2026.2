extends Node2D

class_name Weapon

@export var AttackType: PackedScene
@export var AttackSpeed: float = 1.0
@export var MaxAmmo : int = 5
@export var AmmoPerShot : int = 1

var AttackTimer: float = 0.0
var Enabled: bool = false
var Ready: bool = false
var CurrentAmmo : int = 0
var AutoReload : bool = false

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
		
func _toggle_auto_reload(enable : bool) -> void:
	AutoReload = enable
		
func _attack() -> void:
	var out_of_ammo = CurrentAmmo >= 0 && CurrentAmmo < AmmoPerShot
	if out_of_ammo :
		return
	
	_spawn_attack()
	
	if CurrentAmmo > 0:
		CurrentAmmo -= AmmoPerShot
	
	Ready = false
	if out_of_ammo && AutoReload:
		_reload()
		
func _reload() -> void:
	CurrentAmmo = MaxAmmo
	
func _spawn_attack() -> void:
	var attack = AttackType.instantiate()
	get_tree().root.add_child(attack)
	attack.position = global_position
	attack.rotation = global_rotation
