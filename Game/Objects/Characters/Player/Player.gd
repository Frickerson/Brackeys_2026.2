extends CharacterBase

class_name Player

@export var Camera: Camera2D

static var Distrust : float = 0.0

func _physics_process(_delta: float) -> void:
	var vertical = Input.get_axis("Player_Move_Up","Player_Move_Down")
	var horizontal = Input.get_axis("Player_Move_Left","Player_Move_Right")
	
	velocity = Vector2(horizontal, vertical).normalized() * MoveSpeed
	IsMoving = !velocity.is_zero_approx()

	move_and_slide()
	
	var mouse_position = Camera.get_global_mouse_position()
	var direction = mouse_position - position
	rotation = direction.angle()
	
func _input(event):
	if EquippedWeapon == null:
		return
		
	if event.is_action("Player_Shoot"):
		if event.pressed:
			EquippedWeapon._toggle_attack(true)
		if event.is_released():
			EquippedWeapon._toggle_attack(false)
	
	if event.is_action("Player_Reload"):
		EquippedWeapon._reload()
		
func _process(delta: float) -> void:
	super._process(delta)
	
	_update_distrust(1.0 * delta)
		
static func _update_distrust(value : float) -> void:
	Distrust += value

	if Distrust > 100.0:
		Distrust = 100.0
	
func _get_max_ammo() -> int:
	if EquippedWeapon:
		return EquippedWeapon.MaxAmmo
	return -1
	
func _get_current_ammo() -> int:
	if EquippedWeapon:
		return EquippedWeapon.CurrentAmmo
	return -1
