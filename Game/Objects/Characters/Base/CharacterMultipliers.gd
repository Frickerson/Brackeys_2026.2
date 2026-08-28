extends Resource

class_name CharacterMultipliers

@export var AttackSpeedMultiplier : float = 0.0
@export var DamageMultiplier : float = 0.0
@export var AttackRangeMultiplier : float = 0.0
@export var MovementSpeedMultiplier : float = 0.0
@export var ReloadSpeedMultiplier : float = 0.0
@export var BulletSizeMultiplier : float = 0.0
@export var BulletSpeedMultiplier : float = 0.0
@export var MaxHealthMultiplier : float = 0.0
@export var GoldDropMultiplier : float = 0.0
@export var HealthDropMultiplier : float = 0.0
@export var HomingMultiplier : float = 0.0
@export var AccelerationMultiplier : float = 0.0
@export var DecelerationMultiplier : float = 0.0

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
