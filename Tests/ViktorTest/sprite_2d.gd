extends Sprite2D

var speed = 420
var rotation_speed = PI
var move_enabled = false

func _process(delta: float) -> void:
	if move_enabled == false:
		return
	
	var direction = 0
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1
	
	rotation += rotation_speed * direction * delta
	
	direction = 0
	if Input.is_key_pressed(KEY_W):
		direction = 1
	if Input.is_action_pressed("ui_down"):
		direction = -1
		
	var velocity = Vector2.UP.rotated(rotation)* direction * speed
	position += velocity * delta


func _on_button_pressed() -> void:
	move_enabled = true
