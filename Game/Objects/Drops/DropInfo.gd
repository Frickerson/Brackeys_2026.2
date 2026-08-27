extends Resource

class_name DropInfo

enum Stats {
	Health,
	Gold
}

@export var Name : String = "Gold"
@export var ValueChange : float = 0.0
@export var stat : Stats = Stats.Gold
@export var image : Texture2D
