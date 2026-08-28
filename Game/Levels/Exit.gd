extends Area2D

class_name Exit

func enable():
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	$GPUParticles2D.emitting = true
