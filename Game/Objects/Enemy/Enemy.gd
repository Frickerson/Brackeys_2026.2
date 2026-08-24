extends CharacterBody2D

class_name Enemy

@export var DefaultWeapon: PackedScene
@export var AttackRange: float = 500.0
@export var AttackLocation: Node2D
@export var RayCast : RayCast2D
@export var MoveSpeed : float = 200.0

@onready var NavigationAgent : NavigationAgent2D = $NavigationAgent2D 
@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

var EquippedWeapon: Weapon = null

func _ready() -> void:
	if DefaultWeapon != null:
		EquippedWeapon = DefaultWeapon.instantiate()
		AttackLocation.add_child(EquippedWeapon)
		
	RayCast.add_exception(PlayerRef)

func _physics_process(delta: float) -> void:
	if PlayerRef == null:
		return

	var player_position = PlayerRef.global_position
	_move_towards_player(player_position)
	
	var enable_attack = _in_attack_range(player_position) && _in_line_of_sight(player_position)
	EquippedWeapon._toggle_attack(enable_attack)
	
func _take_damage(damage : float) -> void:
	queue_free()
	
func _move_towards_player(player_position : Vector2) -> void:
	NavigationAgent.target_position = player_position
	
	if NavigationAgent.is_navigation_finished():
		return
	
	var next_position = NavigationAgent.get_next_path_position()
	var dir = global_position.direction_to(next_position)
	velocity = dir * MoveSpeed
	move_and_slide()
	
	var player_dir = AttackLocation.global_position.direction_to(player_position)
	rotation = player_dir.angle()

func _in_attack_range(player_position : Vector2) -> bool:
	if EquippedWeapon == null:
		return false
		
	var squared_distance = global_position.distance_squared_to(player_position)
	return squared_distance <= AttackRange * AttackRange
	
func _in_line_of_sight(player_position : Vector2) -> bool:
	RayCast.target_position = RayCast.to_local(player_position)
	return !RayCast.is_colliding()
