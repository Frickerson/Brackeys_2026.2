extends CharacterBody2D

@export var Attack: PackedScene
@export var MoveSpeed: float = 30000.0
@export var AttackSpeed: float = 1.0
@export var BobSpeed: float = 7.0
@export var BobDifference: float = 0.1

var EnableAttack = false
var AttackTimer = 0.0
var IsMoving = false
var ShouldScaleUp = false
var BobTime = 0.5

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
			EnableAttack = true
		if event.is_released():
			EnableAttack = false

func _process(delta: float) -> void:
	if AttackTimer > 0.0:
		AttackTimer -= delta

	if EnableAttack && AttackTimer <= 0.0:
		_attack()
	
	if IsMoving:
		_update_bobbing(delta)
	else:
		BobTime = lerp(BobTime, 0.5, delta * BobSpeed)
		var new_scale = lerp(1.0 - BobDifference, 1.0 + BobDifference, BobTime)
		scale = Vector2(new_scale, new_scale)
	
func _attack():
	var attack = Attack.instantiate()
	owner.add_child(attack)
	attack.transform = $Marker2D.global_transform
	AttackTimer += 1.0 / AttackSpeed
	
func _update_bobbing(delta: float):
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
