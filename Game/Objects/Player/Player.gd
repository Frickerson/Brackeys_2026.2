extends CharacterBody2D

class_name Player

@export var MoveSpeed: float = 30000.0
@export var BobSpeed: float = 7.0
@export var BobDifference: float = 0.1
@export var DefaultWeapon: PackedScene

var EquippedWeapon: Weapon = null
var IsMoving: bool = false
var ShouldScaleUp: bool = false
var BobTime: float = 0.5

func _ready() -> void:
	EquippedWeapon = DefaultWeapon.instantiate()
	$Marker2D.add_child(EquippedWeapon)

func _physics_process(delta: float) -> void:
	var vertical = delta * MoveSpeed * Input.get_axis("Player_Move_Up","Player_Move_Down")
	var horizontal = delta * MoveSpeed * Input.get_axis("Player_Move_Left","Player_Move_Right")
	
	velocity = Vector2(horizontal, vertical)
	IsMoving = !velocity.is_zero_approx()

	move_and_slide()
	
	var mouse_position = get_viewport().get_mouse_position()
	var direction = mouse_position - position
	rotation = direction.angle()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			EquippedWeapon._toggle_attack(true)
		if event.is_released():
			EquippedWeapon._toggle_attack(false)

func _process(delta: float) -> void:
	if IsMoving:
		_update_bobbing(delta)
	else:
		BobTime = lerp(BobTime, 0.5, delta * BobSpeed)
		var new_scale = lerp(1.0 - BobDifference, 1.0 + BobDifference, BobTime)
		scale = Vector2(new_scale, new_scale)
	
func _update_bobbing(delta: float) -> void:
	if ShouldScaleUp:
		BobTime += delta * BobSpeed
		
		if BobTime >= 1.0:
			ShouldScaleUp = false
			BobTime = 1.0
			
	else:
		BobTime -= delta * BobSpeed
		
		if BobTime <= 0.0:
			ShouldScaleUp = true
			BobTime = 0.0
	
	var new_scale = lerp(1.0 - BobDifference, 1.0 + BobDifference, BobTime)
	scale = Vector2(new_scale, new_scale)

func take_damage (damage : float) -> void:
	pass
