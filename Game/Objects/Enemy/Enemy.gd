extends CharacterBody2D

class_name Enemy

@export var NavigationAgent : NavigationAgent2D
@export var DefaultWeapon: PackedScene
@export var AttackRange: float = 200.0
@export var AttackLocation: Node2D
@export var RayCast : RayCast2D
@export var MoveSpeed : float = 200.0
@export var MinMoveRange : float = 100
@export var MaxMoveRange : float = 300
@export var UseAmmo : bool = false

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

var EquippedWeapon: Weapon = null

func _ready() -> void:
	if get_groups().is_empty():
		add_to_group("Enemy")
	
	if DefaultWeapon != null:
		EquippedWeapon = DefaultWeapon.instantiate()
		AttackLocation.add_child(EquippedWeapon)
		EquippedWeapon.add_to_group(get_groups()[0])
		EquippedWeapon._toggle_uses_ammo(UseAmmo)
		
	RayCast.add_exception(PlayerRef)
	NavigationAgent.target_desired_distance = MinMoveRange

func _physics_process(delta: float) -> void:
	if PlayerRef == null:
		return

	var player_position = PlayerRef.global_position
	var in_move_range = _in_move_range(player_position)
	var in_attack_range = _in_attack_range(player_position)
	var in_line_of_sight = _in_line_of_sight(player_position)
	
	if in_move_range:
		_move_towards_player(player_position)
	
	if in_move_range || (in_attack_range && in_line_of_sight):
		var player_dir = AttackLocation.global_position.direction_to(player_position)
		rotation = player_dir.angle()

	var enable_attack = in_attack_range && in_line_of_sight
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
	NavigationAgent.set_velocity(dir * MoveSpeed)

func _in_attack_range(player_position : Vector2) -> bool:
	if EquippedWeapon == null:
		return false
		
	var squared_distance = global_position.distance_squared_to(player_position)
	return squared_distance <= AttackRange * AttackRange
	
func _in_line_of_sight(player_position : Vector2) -> bool:
	RayCast.target_position = RayCast.to_local(player_position)
	return !RayCast.is_colliding()
	
func _in_move_range(player_position : Vector2) -> bool:
	var distance = global_position.distance_squared_to(player_position)
	return distance <= MaxMoveRange * MaxMoveRange

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
