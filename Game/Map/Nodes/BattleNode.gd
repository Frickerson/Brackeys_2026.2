extends BaseNode

class_name BattleNode

@export var DifficultyMultiplier : float = 1.0

func _get_loaded_level() -> Level:
	var level = super._get_loaded_level()
	level.LevelMultiplier = DifficultyMultiplier
	return level
