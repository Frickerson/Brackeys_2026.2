extends Node2D

class_name Drop

@export var info : DropInfo

func _ready() -> void:
	$Sprite2D.texture = info.image

func apply(player: Player):
	match(info.stat):
		DropInfo.Stats.Health:
			player._take_damage(-info.ValueChange)
		DropInfo.Stats.Gold:
			player.Gold += int(info.ValueChange)
	
	queue_free()
	return


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		apply(body as Player)
	pass

func _initialize(new_info : DropInfo):
	self.info = new_info
	$Sprite2D.texture = info.image
