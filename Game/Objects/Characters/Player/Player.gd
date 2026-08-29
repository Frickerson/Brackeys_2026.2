extends CharacterBase

class_name Player

@export var RespawnTrustDecrease : float = 20.0
@export var RespawnTime : float = 3.0
@export var CameraRef: Camera2D
@export var StarterGold : int = 100
@export_group("Weapon")
@export var UseAmmo : bool = true

static var Trust : float = 100.0
static var Gold : int = -1
static var Multipliers : CharacterMultipliers
static var Relics : Array[Relic]
static var HealthRatio : float = 1.0
static var WeaponClass : PackedScene

var Respawning : bool = false
const hurtStream: AudioStream = preload("res://Game/Sound/Effects/hurt/hurt-a.ogg")

signal TrustDepleted

func _ready() -> void:
	if !Multipliers && DefaultMultipliers:
		Multipliers = DefaultMultipliers
		
	if Gold == -1:
		Gold = StarterGold
		
	if WeaponClass:
		DefaultWeapon = WeaponClass
	else:
		WeaponClass = DefaultWeapon
	
	super._ready()
	HealthBarRef.CurrentHealth = HealthBarRef.MaxHealth * HealthRatio
	
	if EquippedWeapon != null:
		EquippedWeapon._toggle_uses_ammo(UseAmmo)
		
	$HurtAudio.stream = hurtStream

func _physics_process(delta: float) -> void:
	if Respawning:
		return

	var vertical = Input.get_axis("Player_Move_Up","Player_Move_Down")
	var horizontal = Input.get_axis("Player_Move_Left","Player_Move_Right")
	
	var move_direction = Vector2(horizontal, vertical).normalized()
	velocity = calculate_velocity(move_direction, delta, velocity)

	IsMoving = !velocity.is_zero_approx()

	move_and_slide()
	
	var mouse_position = CameraRef.get_global_mouse_position()
	var direction = mouse_position - position
	rotation = direction.angle()
	
func _input(event):
	if EquippedWeapon == null:
		return
		
	if Respawning:
		return
		
	if event.is_action("Player_Shoot"):
		if event.pressed:
			EquippedWeapon._toggle_attack(true)
		if event.is_released():
			EquippedWeapon._toggle_attack(false)
	
	if event.is_action("Player_Reload"):
		EquippedWeapon._reload()
		
func _take_damage(damage : float) -> void:
	super._take_damage(damage)
	HealthRatio = HealthBarRef.CurrentHealth / HealthBarRef.MaxHealth
		
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
	super._update_weapon()
	if EquippedWeapon:
		EquippedWeapon._update_multipliers(_get_multipliers())
		
func _on_death():
	if Trust <= 0.0:
		super._on_death()
		TrustDepleted.emit()
		return
	
	Respawning = true
	HealthBarRef._initialize(int(MaxHealth * _get_multipliers().MaxHealthMultiplier))
	_update_trust(-RespawnTrustDecrease)
	Collision.set_deferred("disabled", true)
	$CollisionShape2D.visible = false
	$HealthBar.visible = false
	EquippedWeapon._toggle_attack(false)
	EquippedWeapon._reset()
	OnDied.emit()
	$ReviveParticles.emitting = true
	var onRespawnComplete = func():
		$ReviveParticles.emitting = false
		$CollisionShape2D.visible = true
		$HealthBar.visible = true
		Respawning = false
		Collision.set_deferred("disabled", false)
		EquippedWeapon._toggle_attack(Input.is_action_pressed("Player_Shoot"))
	
	get_tree().create_timer(RespawnTime).timeout.connect(onRespawnComplete)
	
static func _update_gold(increase : int) -> void:
	Gold = maxi(Gold + increase, 0)

static func _get_multipliers() -> CharacterMultipliers:
	var result : CharacterMultipliers
	
	if Multipliers:
		result = Multipliers.duplicate(true)
	else:
		result = CharacterMultipliers.get_default()
		
	for relic in Relics:
		result._add(relic.MultipliersChange)
	return result
	
static func _add_multipliers(additional_multipliers : CharacterMultipliers) -> void:
	Multipliers._add(additional_multipliers)
	
static func _add_relic(relic : Relic) -> void:
	Relics.push_back(relic)
