extends Node2D

class_name Drop

@export var info : DropInfo
@export var MaxFakePercent : float = 1.0

var IsFake : bool = false
const FakeColor: Color = Color(0.78, 0.172, 0.812, 1.0)
const FakeSound: AudioStream = preload("res://Game/Sound/Effects/Drop/lose-d.ogg")

func _ready() -> void:
	$Sprite2D.texture = info.image

func apply(player: Player):
	match(info.stat):
		DropInfo.Stats.Health:
			player._take_damage(-info.ValueChange)
		DropInfo.Stats.Gold:
			player.Gold += int(info.ValueChange)
	return

func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		return
	
	if IsFake:
		$GPUParticles2D.process_material.color = FakeColor
		$GPUParticles2D.process_material.radial_velocity = Vector2(30,50)
		$GPUParticles2D.emitting = true
		$GPUParticles2D.finished.connect(func(): queue_free())
		$CollisionShape2D.call_deferred("set_disabled", true)
		$Sprite2D.visible = false
		$AudioStreamPlayer2D.stream = FakeSound
		$AudioStreamPlayer2D.play()
		return
		
	
	apply(body as Player)
	$GPUParticles2D.process_material.color = Color.WHITE
	$GPUParticles2D.process_material.radial_velocity = Vector2(-50,-30)
	$GPUParticles2D.emitting = true
	$GPUParticles2D.finished.connect(func(): queue_free())
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Sprite2D.visible = false
	$AudioStreamPlayer2D.play()

func _initialize(new_info : DropInfo):
	self.info = new_info
	$Sprite2D.texture = info.image
	IsFake = randf() < (1.0 - (Player.Trust / 100.0)) * MaxFakePercent
