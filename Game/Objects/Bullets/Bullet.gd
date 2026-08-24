extends Area2D

class_name Bullet

@export var Speed : float = 500.0

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	var velocity = direction * Speed
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	var enemy := body as Enemy
	if enemy:
		enemy._take_damage(1.0)
	
	var player := body as Player
	if player:
		player.take_damage(1.0)
		
	queue_free()

func _on_screen_exited() -> void:
	queue_free()
