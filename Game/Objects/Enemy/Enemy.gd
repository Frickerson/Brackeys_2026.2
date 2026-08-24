extends CharacterBody2D

class_name Enemy

@export var DefaultWeapon: PackedScene
@export var AttackRange: float = 500.0
@export var AttackLocation: Node2D

@onready var NavigationAgent : NavigationAgent2D = $NavigationAgent2D 
@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

var EquippedWeapon: Weapon = null

func _ready() -> void:
	if DefaultWeapon != null:
		EquippedWeapon = DefaultWeapon.instantiate()
		AttackLocation.add_child(EquippedWeapon)

func _physics_process(delta: float) -> void:
	if PlayerRef == null:
		return

	var player_position = PlayerRef.global_position
	_move_towards_player(player_position)
	_check_attack_range(player_position)
	
func _take_damage(damage : float) -> void:
	queue_free()
	
func _move_towards_player(player_position : Vector2) -> void:
	NavigationAgent.target_position = player_position
	
	if NavigationAgent.is_navigation_finished():
		return
	
	var next_position = NavigationAgent.get_next_path_position()
	var dir = global_position.direction_to(next_position)
	velocity = dir * 200.0
	move_and_slide()
	
	var player_dir = global_position.direction_to(player_position)
	rotation = player_dir.angle()

func _check_attack_range(player_position : Vector2) -> void:
	if EquippedWeapon == null:
		return
	
	var squared_distance = global_position.distance_squared_to(player_position)
	var enable = squared_distance <= AttackRange * AttackRange
	EquippedWeapon._toggle_attack(enable)
	
