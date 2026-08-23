extends Area2D

@export var Speed : float = 500.0

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	var velocity = direction * Speed
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Enemy":
		body.queue_free()
	self.queue_free()


func _on_screen_exited() -> void:
	self.queue_free()
