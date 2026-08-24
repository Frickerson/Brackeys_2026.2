extends Node2D

class_name Weapon

@export var AttackType: PackedScene
@export var AttackSpeed: float = 1.0

var AttackTimer: float = 0.0
var Enabled: bool = false
var Ready: bool = false

func _ready() -> void:
	Ready = true

func _process(delta: float) -> void:
	if Ready:
		return
	
	AttackTimer += (1.0 / AttackSpeed) * delta
	if AttackTimer >= 1.0:
		Ready = true
		AttackTimer -= 1.0
	else:
		return
		
	if Enabled:
		_attack()
		
func _toggle_attack(enable: bool) -> void:
	if enable == Enabled:
		return

	Enabled = enable
	if Enabled && Ready:
		_attack()
		
func _attack() -> void:
	var attack = AttackType.instantiate()
	get_tree().root.add_child(attack)
	attack.position = global_position
	attack.rotation = global_rotation
	
	Ready = false
