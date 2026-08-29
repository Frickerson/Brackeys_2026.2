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
	AccelerationMultiplier += other.AccelerationMultiplier
	DecelerationMultiplier += other.DecelerationMultiplier
	
func _get_additive_text() -> String:
	var result = ""
	result += _get_modifier_text(AttackSpeedMultiplier, "Attack Speed")
	result += _get_modifier_text(AttackRangeMultiplier, "Attack Range")
	result += _get_modifier_text(DamageMultiplier, "Damage")
	result += _get_modifier_text(MovementSpeedMultiplier, "Movement Speed")
	result += _get_modifier_text(ReloadSpeedMultiplier, "Reload Speed")
	result += _get_modifier_text(BulletSizeMultiplier, "Bullet Size")
	result += _get_modifier_text(BulletSpeedMultiplier, "Bullet Speed")
	result += _get_modifier_text(MaxHealthMultiplier, "Max Health")
	result += _get_modifier_text(GoldDropMultiplier, "Gold Drop Size")
	result += _get_modifier_text(HealthDropMultiplier, "Health Drop Size")
	result += _get_modifier_text(HomingMultiplier, "Homing Strength")
	result += _get_modifier_text(AccelerationMultiplier, "Acceleration")
	result += _get_modifier_text(DecelerationMultiplier, "Deceleration")
		
	return result
	
func _get_modifier_text(multiplier : float, name : String) -> String:
	if multiplier == 0.0:
		return ""
		
	var sign : String
	if multiplier > 0.0:
		sign =  "+"
	else:
		sign =  ""	
		
	return str(name, " ", sign, multiplier * 100, "%", "\n")
