extends Weapon

@export var Angle : float = 45.0

func _spawn_attack(shots : int, index : int) -> Node:
	var angle_offset = Angle / shots
	var rotation_offset = angle_offset * index
	var attack = _create_attack()
	attack.global_position = global_position
	attack.global_rotation = global_rotation + deg_to_rad(rotation_offset)
	return attack
