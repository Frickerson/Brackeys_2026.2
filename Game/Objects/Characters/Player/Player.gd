extends CharacterBase

class_name Player

@export var RespawnTrustDecrease : float = 20.0
@export var RespawnTime : float = 3.0
@export var Camera: Camera2D
@export var StarterGold : int = 100

static var Trust : float = 100.0
static var Gold : int = -1
static var Multipliers : CharacterMultipliers
static var Relics : Array[Relic]
static var Health : float = -1.0

var Respawning : bool = false

func _ready() -> void:
	if !Multipliers && DefaultMultipliers:
		Multipliers = DefaultMultipliers
		
	if Gold == -1:
		Gold = StarterGold
	
	super._ready()
	
	if Health == -1.0:
		Health = HealthBarRef.CurrentHealth
	else:
		HealthBarRef.CurrentHealth = Health

func _physics_process(_delta: float) -> void:
	if Respawning:
		return

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
	Health = HealthBarRef.CurrentHealth
		
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
	EquippedWeapon.ReloadIcon = $Reload
	if EquippedWeapon:
		EquippedWeapon._update_multipliers(_get_multipliers())
		
func _on_death():
	if Trust <= 0.0:
		super._on_death()
		return
	
	Respawning = true
	HealthBarRef._initialize(MaxHealth)
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
	
	get_tree().create_timer(RespawnTime).timeout.connect(onRespawnComplete)
	
static func _update_gold(increase : int) -> void:
	Gold = maxi(Gold + increase, 0)

static func _get_multipliers() -> CharacterMultipliers:
	var result = Multipliers.duplicate(true)
	for relic in Relics:
		result._add(relic.MultipliersChange)
	return result
	
static func _add_multipliers(additional_multipliers : CharacterMultipliers) -> void:
	Multipliers._add(additional_multipliers)
	
static func _add_relic(relic : Relic) -> void:
	Relics.push_back(relic)
