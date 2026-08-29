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
	result += _get_modifier_additive_text(AttackSpeedMultiplier, "Attack Speed")
	result += _get_modifier_additive_text(AttackRangeMultiplier, "Attack Range")
	result += _get_modifier_additive_text(DamageMultiplier, "Damage")
	result += _get_modifier_additive_text(MovementSpeedMultiplier, "Movement Speed")
	result += _get_modifier_additive_text(ReloadSpeedMultiplier, "Reload Speed")
	result += _get_modifier_additive_text(BulletSizeMultiplier, "Bullet Size")
	result += _get_modifier_additive_text(BulletSpeedMultiplier, "Bullet Speed")
	result += _get_modifier_additive_text(MaxHealthMultiplier, "Max Health")
	result += _get_modifier_additive_text(GoldDropMultiplier, "Gold Drop Size")
	result += _get_modifier_additive_text(HealthDropMultiplier, "Health Drop Size")
	result += _get_modifier_additive_text(HomingMultiplier, "Homing Strength")
	result += _get_modifier_additive_text(AccelerationMultiplier, "Acceleration")
	result += _get_modifier_additive_text(DecelerationMultiplier, "Deceleration")
		
	return result
	
func _get_modifier_additive_text(multiplier : float, name : String) -> String:
	if multiplier == 0.0:
		return ""
		
	var mutliplier_sign : String
	if multiplier > 0.0:
		mutliplier_sign =  "+"
	else:
		mutliplier_sign =  ""	
		
	return str(name, " ", mutliplier_sign, multiplier * 100, "%", "\n")

func _get_total_text() -> String:
	var result = ""
	result += _get_modifier_total_text(AttackSpeedMultiplier, "Attack Speed")
	result += _get_modifier_total_text(AttackRangeMultiplier, "Attack Range")
	result += _get_modifier_total_text(DamageMultiplier, "Damage")
	result += _get_modifier_total_text(MovementSpeedMultiplier, "Movement Speed")
	result += _get_modifier_total_text(ReloadSpeedMultiplier, "Reload Speed")
	result += _get_modifier_total_text(BulletSizeMultiplier, "Bullet Size")
	result += _get_modifier_total_text(BulletSpeedMultiplier, "Bullet Speed")
	result += _get_modifier_total_text(MaxHealthMultiplier, "Max Health")
	result += _get_modifier_total_text(GoldDropMultiplier, "Gold Drop Size")
	result += _get_modifier_total_text(HealthDropMultiplier, "Health Drop Size")
	result += _get_modifier_total_text(HomingMultiplier + 1.0, "Homing Strength")
	result += _get_modifier_total_text(AccelerationMultiplier, "Acceleration")
	result += _get_modifier_total_text(DecelerationMultiplier, "Deceleration")
		
	return result
	
func _get_modifier_total_text(multiplier : float, name : String) -> String:
	var total_multiplier = multiplier - 1.0
	
	var color = "white"
	var multiplier_sign = ""
	if total_multiplier > 0.0:
		multiplier_sign =  "+"
		color = "green"
		
	if total_multiplier < 0.0:
		color = "red"
		
	return str(name, " ", "[color=", color, "]", multiplier_sign, total_multiplier * 100, "%[/color]", "\n")
	
static func get_default() -> CharacterMultipliers:
	var result = CharacterMultipliers.new()
	result.AttackSpeedMultiplier = 1.0
	result.AttackRangeMultiplier = 1.0
	result.DamageMultiplier = 1.0
	result.MovementSpeedMultiplier = 1.0
	result.ReloadSpeedMultiplier = 1.0
	result.BulletSizeMultiplier = 1.0
	result.BulletSpeedMultiplier = 1.0
	result.MaxHealthMultiplier = 1.0
	result.GoldDropMultiplier = 1.0
	result.HealthDropMultiplier = 1.0
	result.HomingMultiplier = 0.0
	result.AccelerationMultiplier = 1.0
	result.DecelerationMultiplier = 1.0
	
	return result

static func _get_random_multiplier(amount : float) -> CharacterMultipliers:
	var result = CharacterMultipliers.new()
	var multiplier_array = [
			amount,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
			0.0,
		]
	
	multiplier_array.shuffle()
	
	result.AttackSpeedMultiplier = multiplier_array[0]
	result.AttackRangeMultiplier = multiplier_array[1]
	result.DamageMultiplier = multiplier_array[2]
	result.MovementSpeedMultiplier = multiplier_array[3]
	result.ReloadSpeedMultiplier = multiplier_array[4]
	result.BulletSizeMultiplier = multiplier_array[5]
	result.BulletSpeedMultiplier = multiplier_array[6]
	result.MaxHealthMultiplier = multiplier_array[7]
	result.GoldDropMultiplier = multiplier_array[8]
	result.HealthDropMultiplier = multiplier_array[9]
	result.HomingMultiplier = multiplier_array[10]
	result.AccelerationMultiplier = multiplier_array[11]
	result.DecelerationMultiplier = multiplier_array[12]
	
	return result
