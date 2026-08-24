extends CharacterBody2D

class_name Enemy

@onready var NavigationAgent : NavigationAgent2D = $NavigationAgent2D 

func _ready() -> void:
	NavigationAgent.target_position = global_position + Vector2(300.0, 0.0)
	
func _physics_process(delta: float) -> void:
	var velocity = global_position.direction_to(NavigationAgent.get_next_path_position()) * 200.0
	position += velocity * delta

func _take_damage(damage : float) -> void:
	queue_free()
