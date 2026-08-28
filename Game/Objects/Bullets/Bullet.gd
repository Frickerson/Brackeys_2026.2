extends Area2D

class_name Bullet

@export var BulletSprite: Sprite2D
@export var FakeColor : Color = Color.RED
@export var FakeColorCurve : float = 0.4
@export var FadeOutCurve : float = 5.0
@export var ColorPerTeam : Dictionary[StringName, Color]
@export var HomingSpeed : float = 10.0

var Speed : float = 0.0
var Damage : float = 0.0
var LifeSpan : float = 0.0
var LifeTimer : float = 0.0
var IsFake : bool = false
var DefaultColor : Color
var Deleting : bool = false
var HomingPercentage : float = 0.0

func _ready() -> void:
	var color = ColorPerTeam.get(get_groups()[0])
	DefaultColor = color
	BulletSprite.self_modulate = color

func _process(delta: float) -> void:
	if Deleting:
		return
	LifeTimer += delta
	if LifeTimer >= LifeSpan:
		queue_free()
	
	if IsFake:
		var fake_weight = clampf(ease(LifeTimer / LifeSpan, FakeColorCurve) * 2 - 1, 0.0, 1.0)
		BulletSprite.self_modulate = DefaultColor.lerp(FakeColor, fake_weight)
	
	var transparency_weight = clampf(ease(LifeTimer / LifeSpan, FadeOutCurve) * 2 - 1, 0.0, 1.0)
	var transparency = lerpf(1.0, 0.0, transparency_weight)
	BulletSprite.self_modulate.a = transparency
		
func _physics_process(delta: float) -> void:
	var homing_direction = _get_homing_direction()
	var current_direction = Vector2.RIGHT.rotated(rotation)
	
	var homing_test = current_direction.lerp(homing_direction, HomingPercentage * delta * HomingSpeed)
	global_rotation = homing_test.angle()
	
	var direction = Vector2.RIGHT.rotated(rotation)
	var velocity = direction * Speed
	global_position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if IsFake:
		return
		
	if is_in_group("PlayerTeam") && body.is_in_group("Player"):
		return
	
	if is_in_group("EnemyTeam") && body.is_in_group("Enemy"):
		return
		
	var character := body as CharacterBase
	if character:
		$HitParticles.process_material.color = Color.RED
		character._take_damage(Damage)
	else:
		$HitParticles.process_material.color = Color.WHITE
	
	$HitParticles.emitting = true
	$HitParticles.finished.connect(func(): queue_free())
	$CollisionShape2D.queue_free()
	Deleting = true
	
func _initialize(damage : float, shot_speed: float, shot_life_span : float, bullet_sprite: Texture2D, homing_percentage : float) -> void:
	Damage = damage
	Speed = shot_speed
	LifeSpan = shot_life_span
	$CollisionShape2D/Sprite2D.texture = bullet_sprite
	HomingPercentage = homing_percentage
	
func _get_homing_direction() -> Vector2:
	var player_ref : Player = get_tree().get_first_node_in_group("Player")
	
	if is_in_group("PlayerTeam"):
		return global_position.direction_to(player_ref.Camera.get_global_mouse_position())
		
	if is_in_group("EnemyTeam"):
		return global_position.direction_to(player_ref.global_position)
		
	return Vector2.ZERO
