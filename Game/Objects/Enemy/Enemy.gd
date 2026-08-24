extends RigidBody2D

class_name Enemy

func _take_damage(damage : float) -> void:
	queue_free()
