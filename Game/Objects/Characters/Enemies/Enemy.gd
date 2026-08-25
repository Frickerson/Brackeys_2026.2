extends CharacterBase

class_name Enemy

@export var NavigationAgent : NavigationAgent2D
@export var AttackRange: float = 200.0
@export var RayCast : RayCast2D
@export var MinMoveRange : float = 100
@export var MaxMoveRange : float = 300
@export var UseAmmo : bool = false

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	super._ready()
	
	if EquippedWeapon != null:
		EquippedWeapon._toggle_uses_ammo(UseAmmo)
		
	RayCast.add_exception(PlayerRef)

func _physics_process(delta: float) -> void:
	if PlayerRef == null:
		EquippedWeapon._toggle_attack(false)
		return

	var player_position = PlayerRef.global_position
	var in_move_range = _in_move_range(player_position)
	var in_attack_range = _in_attack_range(player_position)
	var in_line_of_sight = _in_line_of_sight(player_position)
	
	if in_move_range:
		_move_towards_player(player_position, in_line_of_sight)
	
	if in_move_range || (in_attack_range && in_line_of_sight):
		var player_dir = AttackLocation.global_position.direction_to(player_position)
		rotation = player_dir.angle()

	var enable_attack = in_attack_range && in_line_of_sight
	EquippedWeapon._toggle_attack(enable_attack)
	
func _move_towards_player(player_position : Vector2, in_line_of_sight : bool) -> void:
	var dir_from_player = player_position.direction_to(global_position)
	if !in_line_of_sight:
		dir_from_player = dir_from_player.rotated(deg_to_rad(10.0))
	
	var target_position = player_position + dir_from_player * MinMoveRange
	NavigationAgent.target_position = target_position
		
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
	IsMoving = !velocity.is_zero_approx()
	move_and_slide()
