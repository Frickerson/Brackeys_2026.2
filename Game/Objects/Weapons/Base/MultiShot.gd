extends Weapon

@export var Angle : float = 45.0

func _spawn_attack() -> void:
	var angle_offset = Angle / AmmoPerShot
	
	for index in AmmoPerShot:
		var rotation_offset = angle_offset * index
		var attack = _create_attack()
		attack.global_position = global_position
		attack.global_rotation = global_rotation + deg_to_rad(rotation_offset)
