extends CharacterBody2D

class_name Enemy

@onready var NavigationAgent : NavigationAgent2D = $NavigationAgent2D 
@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if PlayerRef == null:
		return

	var player_position = PlayerRef.global_position
	NavigationAgent.target_position = player_position
	
	if NavigationAgent.is_navigation_finished():
		return
	
	var next_position = NavigationAgent.get_next_path_position()
	var dir = global_position.direction_to(next_position)
	velocity = dir * 200.0
	move_and_slide()
	
	rotation = velocity.normalized().angle()
	
func _take_damage(damage : float) -> void:
	queue_free()
