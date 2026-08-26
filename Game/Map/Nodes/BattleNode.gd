extends BaseNode

class_name BattleNode

@export var DifficultyMultiplier : float = 1.0

func _load_level() -> Level:
	var level = super._load_level()
	level.LevelMultiplier = DifficultyMultiplier
	return level
