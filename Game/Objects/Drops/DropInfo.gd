extends Resource

class_name DropInfo

enum Stats {
	Health,
	Gold
}

@export var Name : String = "Gold"
@export var ValueChange : float = 0.0:
	get:
		var multipliers = Player._get_multipliers()
		if multipliers:
			match(stat):
				DropInfo.Stats.Health:
					return ValueChange * multipliers.HealthDropMultiplier
				DropInfo.Stats.Gold:
					return ValueChange * multipliers.GoldDropMultiplier
		return ValueChange
		

@export var stat : Stats = Stats.Gold
@export var image : Texture2D
@export var Chance : float = 0.5
