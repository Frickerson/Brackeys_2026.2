extends Area2D

class_name Bullet

@export var BulletSprite: Sprite2D
@export var FakeColor : Color = Color.RED
@export var FakeColorCurve : float = 0.4
@export var FadeOutCurve : float = 5.0
@export var ColorPerTeam : Dictionary[StringName, Color]

var Speed : float = 0.0
var Damage : float = 0.0
var LifeSpan : float = 0.0
var LifeTimer : float = 0.0
var IsFake : bool = false
var DefaultColor : Color

func _ready() -> void:
	var groups = get_groups()
	var color = ColorPerTeam.get(get_groups()[0])
	DefaultColor = color
	BulletSprite.modulate = color

func _process(delta: float) -> void:
	LifeTimer += delta
	if LifeTimer >= LifeSpan:
		queue_free()
	
	if IsFake:
		var fake_weight = clampf(ease(LifeTimer / LifeSpan, FakeColorCurve) * 2 - 1, 0.0, 1.0)
		BulletSprite.modulate = DefaultColor.lerp(FakeColor, fake_weight)
	
	var transparency_weight = clampf(ease(LifeTimer / LifeSpan, FadeOutCurve) * 2 - 1, 0.0, 1.0)
	var transparency = lerpf(1.0, 0.0, transparency_weight)
	BulletSprite.modulate.a = transparency
		
func _physics_process(delta: float) -> void:
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
		character._take_damage(Damage)
		
	queue_free()
	
func _initialize(damage : float, shot_speed: float, shot_life_span : float, bullet_sprite: Texture2D) -> void:
	Damage = damage
	Speed = shot_speed
	LifeSpan = shot_life_span
	$CollisionShape2D/Sprite2D.texture = bullet_sprite
