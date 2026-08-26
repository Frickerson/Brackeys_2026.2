extends BaseNode

class_name EventNode

@export var Title : String = "Test Title"
@export var Descrition : String = "This is a description"
@export var Options : Array[Dictionary] = [{
	Title = "Option",
	Distrust = 0.0,
	MultiplierIncrease = 0.0
}]

func _ready() -> void:
	print(Options[0].Title)

func _load_level() -> Level:
	var level : EventLevel = super._load_level()
	level._set_title(Title)
	level._set_description(Descrition)
	level._set_options(Options)
	return level
