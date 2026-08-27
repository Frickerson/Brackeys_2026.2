extends Enemy
class_name Sniper

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	
	if Dying: 
		return
	if PlayerRef == null:
		return
	if PlayerRef.Respawning:
		return
	
	$Laser.clear_points()
	$Laser.add_point(Vector2(0,0),0)
	if RayCast.is_colliding():
		$Laser.add_point(to_local(RayCast.get_collision_point()))
	else:
		$Laser.add_point(to_local(PlayerRef.global_position))
