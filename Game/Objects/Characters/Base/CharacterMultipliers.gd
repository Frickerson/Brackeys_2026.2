extends Resource

class_name CharacterMultipliers

@export var AttackSpeedMultiplier : float = 1.0
@export var DamageMultiplier : float = 1.0
@export var AttackRangeMultiplier : float = 1.0
@export var MovementSpeedMultiplier : float = 1.0
@export var ReloadSpeedMultiplier : float = 1.0
@export var BulletSizeMultiplier : float = 1.0
@export var BulletSpeedMultiplier : float = 1.0
@export var MaxHealthMultiplier : float = 1.0
@export var GoldDropMultiplier : float = 1.0
@export var HealthDropMultiplier : float = 1.0
@export var HomingMultiplier : float = 0.0
@export var AccelerationMultiplier : float = 1.0
@export var DecelerationMultiplier : float = 1.0

func _add(other : CharacterMultipliers) -> void:
	AttackSpeedMultiplier += other.AttackSpeedMultiplier
	AttackRangeMultiplier += other.AttackRangeMultiplier
	DamageMultiplier += other.DamageMultiplier
	MovementSpeedMultiplier += other.MovementSpeedMultiplier
	ReloadSpeedMultiplier += other.ReloadSpeedMultiplier
	BulletSizeMultiplier += other.BulletSizeMultiplier
	BulletSpeedMultiplier += other.BulletSpeedMultiplier
	MaxHealthMultiplier += other.MaxHealthMultiplier
	GoldDropMultiplier += other.GoldDropMultiplier
	HealthDropMultiplier += other.HealthDropMultiplier
	HomingMultiplier += other.HomingMultiplier
