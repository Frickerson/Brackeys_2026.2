extends Area2D

class_name Bullet

@export var Speed : float = 500.0

var Damage : float = 0.0

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	var velocity = direction * Speed
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	for group in get_groups():
		if body.is_in_group(group):
			return
	
	var character := body as CharacterBase
	if character:
		character._take_damage(Damage)
		
	queue_free()

func _on_screen_exited() -> void:
	queue_free()
	
func _initialize(damage : float) -> void:
	Damage = damage
