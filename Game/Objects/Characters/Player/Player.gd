extends CharacterBase

class_name Player

@export var Camera: Camera2D

static var Trust : float = 100.0
static var Multipliers : CharacterMultipliers

func _ready() -> void:
	if !Multipliers && DefaultMultipliers:
		Multipliers = DefaultMultipliers
	
	super._ready()

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
		
static func _update_trust(value : float) -> void:
	Trust = clampf(Trust + value, 0.0, 100.0)
	
func _get_max_ammo() -> int:
	if EquippedWeapon:
		return EquippedWeapon.MaxAmmo
	return -1
	
func _get_current_ammo() -> int:
	if EquippedWeapon:
		return EquippedWeapon.CurrentAmmo
	return -1
	
func _update_weapon() -> void:
	if EquippedWeapon:
		EquippedWeapon._update_multipliers(_get_multipliers())
		
func _on_death():
	if Trust <= 0.0:
		super._on_death()
		return
	
	visible = false
	HealthBarRef._initialize(MaxHealth)
	_update_trust(-20.0)
	await get_tree().create_timer(3.0).timeout
	visible = true

static func _get_multipliers() -> CharacterMultipliers:
	return Multipliers
	
static func _add_multipliers(additional_multipliers : CharacterMultipliers) -> void:
	Multipliers._add(additional_multipliers)
