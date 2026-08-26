extends Area2D

class_name Bullet

@export var BulletSprite: Sprite2D
@export var FakeColor : Color = Color.RED

var Speed : float = 0.0
var Damage : float = 0.0
var LifeSpan : float = 0.0
var LifeTimer : float = 0.0
var IsFake : bool = false
var DefaultColor : Color

func _ready() -> void:
	DefaultColor = BulletSprite.self_modulate

func _process(delta: float) -> void:
	LifeTimer += delta
	if LifeTimer >= LifeSpan:
		queue_free()
		
	var desired_color = Color.TRANSPARENT
	if IsFake:
		BulletSprite.self_modulate = lerp(DefaultColor, FakeColor, ease(LifeTimer / LifeSpan, 0.3))

	BulletSprite.modulate = lerp(Color.WHITE, Color.TRANSPARENT, ease( LifeTimer / LifeSpan, 5.0))
		
func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	var velocity = direction * Speed
	global_position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if is_in_group("PlayerTeam") && body.is_in_group("Player"):
		return
	
	if is_in_group("EnemyTeam") && body.is_in_group("Enemy"):
		return
		
	var character := body as CharacterBase
	if character:
		if !IsFake:
			character._take_damage(Damage)
		
	queue_free()
	
func _initialize(damage : float, shot_speed: float, shot_life_span : float) -> void:
	Damage = damage
	Speed = shot_speed
	LifeSpan = shot_life_span
