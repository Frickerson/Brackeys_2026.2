extends Node2D

class_name Weapon

@export var AttackType: PackedScene
@export var AttackSpeed: float = 1.0:
	get:
		return AttackSpeed * AttackSpeedMultiplier
@export var MaxAmmo : int = 5
@export var AmmoPerShot : int = 1
@export var Damage : float = 5.0:
	get:
		return Damage * DamageMultiplier
@export var ShotSpeed : float = 500.0
@export var ShotLifeSpan : float = 5.0
@export var SoundEffect: AudioStream
@export var BulletSprite: AtlasTexture
@export var ReloadTime : float = 1.0
@export var MaxFakeShots : int = 3

var AttackTimer: float = 0.0
var Enabled: bool = false
var Ready: bool = false
var CurrentAmmo : int = 0
var UsesAmmo : bool = true
var AttackSpeedMultiplier : float = 1.0
var DamageMultiplier : float = 1.0
var Reloading : bool = false

func _ready() -> void:
	Ready = true
	CurrentAmmo = MaxAmmo
	$AudioStreamPlayer2D.set_stream(SoundEffect)

func _process(delta: float) -> void:
	if Ready:
		if Enabled:
			_attack()
		return
	
	AttackTimer += AttackSpeed * delta
	if AttackTimer >= 1.0:
		Ready = true
		AttackTimer -= 1.0
		
func _toggle_attack(enable: bool) -> void:
	if enable == Enabled:
		return

	Enabled = enable
	if Enabled && Ready:
		_attack()
		
func _toggle_uses_ammo(use_ammo : bool) -> void:
	UsesAmmo = use_ammo
		
func _attack() -> void:
	var out_of_ammo = CurrentAmmo >= 0 && CurrentAmmo < AmmoPerShot
	if out_of_ammo :
		return
		
	if Reloading:
		return
	
	_spawn_attack()
	play_sound()
	$ShotParticleEffect.restart()
	
	if UsesAmmo && CurrentAmmo > 0:
		CurrentAmmo -= AmmoPerShot
	
	Ready = false
		
func _reload() -> void:
	Reloading = true
	await get_tree().create_timer(ReloadTime).timeout
	
	CurrentAmmo = MaxAmmo
	Reloading = false
	
func _spawn_attack() -> void:
	var right_vector = Vector2.UP.rotated(global_rotation)
	var shots = _get_total_shots()
	var offset = 10.0
	var attacks = []
	for index in shots:
		var test = index - shots / 2.0
		var current_offset = offset * (index - (shots - 1) / 2.0) * right_vector
		var attack = _create_attack()
		attack.global_position = global_position + current_offset
		attack.global_rotation = global_rotation
		attacks.push_back(attack)
	_apply_fake_shots(attacks)

	
func _create_attack() -> Node:
	var attack = AttackType.instantiate() as Bullet
	attack.add_to_group(get_groups()[0])
	attack._initialize(Damage, ShotSpeed, ShotLifeSpan)
	get_tree().root.add_child(attack)
	
	return attack
	
func _update_multipliers(attack_speed_multiplier : float, damage_multiplier : float) -> void:
	AttackSpeedMultiplier = attack_speed_multiplier
	DamageMultiplier = damage_multiplier
	
func play_sound():
	$AudioStreamPlayer2D.play()
	
func _get_total_shots() -> int:
	return AmmoPerShot + _get_fake_shots()
	
func _get_fake_shots() -> int:
	var distrust = Player.Distrust / 100.0
	return floor(distrust * MaxFakeShots)
	
func _apply_fake_shots(shots : Array) -> void:
	var fake_shots = _get_fake_shots()
	shots.shuffle()
	for index in fake_shots:
		var attack := shots.get(index) as Bullet
		attack.IsFake = true
