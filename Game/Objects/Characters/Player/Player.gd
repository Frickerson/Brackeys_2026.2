extends CharacterBase

class_name Player

@export var Camera: Camera2D

var Distrust : float = 0.0

func _physics_process(delta: float) -> void:
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
	
	update_distrust(10.0 * delta)
		
func update_distrust(value : float) -> void:
	Distrust += value
