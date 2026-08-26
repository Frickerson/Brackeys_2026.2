extends Resource

class_name CharacterMultipliers

@export var AttackSpeedMultiplier : float = 1.0
@export var DamageMultiplier : float = 1.0
@export var AttackRangeMultiplier : float = 1.0

func _add(other : CharacterMultipliers) -> void:
	AttackSpeedMultiplier += other.AttackSpeedMultiplier
	AttackRangeMultiplier += other.AttackRangeMultiplier
	DamageMultiplier += other.DamageMultiplier
