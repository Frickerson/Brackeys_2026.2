extends Node2D

class_name Weapon

@export var ReloadIcon: TextureProgressBar

@export var AttackType: PackedScene
@export var AttackSpeed: float = 1.0:
	get:
		if Multipliers:
			return AttackSpeed * Multipliers.AttackSpeedMultiplier
		return AttackSpeed
		
@export var MaxAmmo : int = 5
@export var AmmoPerShot : int = 1
@export var Damage : float = 5.0:
	get:
		if Multipliers:
			return Damage * Multipliers.DamageMultiplier
		return Damage
@export var ShotSpeed : float = 200.0:
	get:
		if Multipliers:
			return ShotSpeed * Multipliers.BulletSpeedMultiplier
		return ShotSpeed
@export var SoundEffect: AudioStream
@export var BulletSprite: Texture2D
@export var ReloadTime : float = 1.0:
	get:
		if Multipliers:
			return ReloadTime / Multipliers.ReloadSpeedMultiplier
		return ReloadTime
@export var MaxFakeShots : int = 3
@export var AttackRange: float = 200.0:
	get:
		if Multipliers:
			return AttackRange * Multipliers.AttackRangeMultiplier
		return AttackRange

var AttackTimer: float = 0.0
var Enabled: bool = false
var Ready: bool = false
var CurrentAmmo : int = 0
var UsesAmmo : bool = true
var Multipliers : CharacterMultipliers = null
var Reloading : bool = false
var OutOfAmmo : bool = false
var LevelRoot : Node2D

func _ready() -> void:
	Ready = true
	CurrentAmmo = MaxAmmo
	$ShotSound.set_stream(SoundEffect)
	LevelRoot = get_tree().get_first_node_in_group("LevelRoot")

func _process(delta: float) -> void:
	if Reloading && ReloadIcon:
		ReloadIcon.value += delta

	if Ready:
		if Enabled && !OutOfAmmo:
			_attack()
		return
	
	AttackTimer += AttackSpeed * delta
	if AttackTimer >= 1.0:
		Ready = true
		AttackTimer -= 1.0
		
func _toggle_attack(enable: bool) -> void:
	if enable == Enabled:
		return
		
	if Reloading:
		return

	Enabled = enable
	
	if Enabled:
		if OutOfAmmo:
			$EmptyGunSound.play()
			return
	
		if Ready:
			_attack()
		
func _toggle_uses_ammo(use_ammo : bool) -> void:
	UsesAmmo = use_ammo
		
func _attack() -> void:
	OutOfAmmo = CurrentAmmo >= 0 && CurrentAmmo < AmmoPerShot
	if OutOfAmmo :
		Ready = false
		$EmptyGunSound.play()
		return
		
	if Reloading:
		return
	
	_spawn_attacks()
	play_sound()
	$ShotParticleEffect.restart()
	
	if UsesAmmo && CurrentAmmo > 0:
		CurrentAmmo -= AmmoPerShot
	
	Ready = false
		
func _reload() -> void:
	if CurrentAmmo == MaxAmmo:
		return
	if Reloading:
		return
		
	Reloading = true
	if ReloadIcon: 
		ReloadIcon.max_value = ReloadTime
		ReloadIcon.value = 0.0
		ReloadIcon.visible = true
	
	var finish_reload = func():
		CurrentAmmo = MaxAmmo
		OutOfAmmo = false
		Reloading = false
		ReloadIcon.visible = false
	
	get_tree().create_timer(ReloadTime).timeout.connect(finish_reload)
	
	
func _spawn_attacks() -> void:
	var shots = _get_total_shots()
	var attacks = []
	for index in shots:
		var attack = _spawn_attack(shots, index)
		attacks.push_back(attack)
	_apply_fake_shots(attacks)
	
func _spawn_attack(shots : int, index : int) -> Node:
	var right_vector = Vector2.UP.rotated(global_rotation)
	var offset = 10.0
	var current_offset = offset * (index - (shots - 1) / 2.0) * right_vector
	var attack = _create_attack()
	attack.global_position = global_position + current_offset
	attack.global_rotation = global_rotation
	return attack

	
func _create_attack() -> Node:
	var attack = AttackType.instantiate() as Bullet
	attack.add_to_group(get_groups()[0])
	var life_span = AttackRange / ShotSpeed
	attack._initialize(Damage, ShotSpeed, life_span, BulletSprite)
	if Multipliers:
		attack.scale *= Multipliers.BulletSizeMultiplier
	LevelRoot.add_child(attack)
	
	return attack
	
func _update_multipliers(multipliers : CharacterMultipliers) -> void:
	Multipliers = multipliers
	
func play_sound():
	$ShotSound.play()
	
func _get_total_shots() -> int:
	return AmmoPerShot + _get_fake_shots()
	
func _get_fake_shots() -> int:
	var distrust = 1.0 - Player.Trust / 100.0
	return floor(distrust * MaxFakeShots)
	
func _apply_fake_shots(shots : Array) -> void:
	var fake_shots = _get_fake_shots()
	shots.shuffle()
	for index in fake_shots:
		var attack := shots.get(index) as Bullet
		attack.IsFake = true
