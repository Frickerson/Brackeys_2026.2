extends Bullet

class_name BulletSpiral

@export var SpiralSpeed : float = 5.0

var CurrentAngle : float = 0.0

func _physics_process(delta: float) -> void:
	CurrentAngle += delta * 5.0
	super._physics_process(delta)
	
func _get_move_direction() -> Vector2:
	return Vector2.RIGHT.rotated(global_rotation + cos( CurrentAngle ))
