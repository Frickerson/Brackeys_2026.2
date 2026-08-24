extends Weapon

@export var Angle : float = 45.0

func _spawn_attack() -> void:
	for index in AmmoPerShot:
		var adjusted_index = index - floor(AmmoPerShot / 2.0)
		var angle_offset = Angle / (AmmoPerShot - 1)
		var rotation_offset = angle_offset * adjusted_index
		
		var attack = AttackType.instantiate()
		get_tree().root.add_child(attack)
		attack.global_position = global_position
		attack.global_rotation = global_rotation + deg_to_rad(rotation_offset)
