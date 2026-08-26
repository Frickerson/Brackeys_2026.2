extends BaseNode

class_name EventNode

@export var Title : String = "Test Title"
@export var Descrition : String = "This is a description"
@export var Options : Array[EventOption]

func _load_level() -> Level:
	var level : EventLevel = super._load_level()
	level._set_title(Title)
	level._set_description(Descrition)
	level._set_options(Options)
	return level
