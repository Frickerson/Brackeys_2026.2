extends BaseNode

class_name BattleNode

@export var DifficultyMultiplier : CharacterMultipliers = null

func _load_level() -> Level:
	var level = super._load_level()
	level.LevelMultiplier = DifficultyMultiplier
	return level
