extends CharacterBase

class_name Enemy

@export_group("Weapon")
@export var UseAmmo : bool = false

@export_group("Movement")
@export var MinMoveRange : float = 100.0
@export var MaxMoveRange : float = 300.0
@export var AvoidanceRadius : float = 30.0

@export_group("")
@export var NavigationAgent : NavigationAgent2D
@export var RayCast : RayCast2D

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

static var Multipliers : CharacterMultipliers
static var AdditionalMultipliers : CharacterMultipliers

func _ready() -> void:
	if !Multipliers && DefaultMultipliers:
		Multipliers = DefaultMultipliers
	
	super._ready()
	
	if EquippedWeapon != null:
		EquippedWeapon._toggle_uses_ammo(UseAmmo)
		
	RayCast.add_exception(PlayerRef)
	NavigationAgent.radius = AvoidanceRadius

func _physics_process(_delta: float) -> void:
	if Dying:
		return
	
	if PlayerRef == null:
		EquippedWeapon._toggle_attack(false)
		NavigationAgent.set_velocity(Vector2.ZERO)
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
	var dir_from_player = player_position.direction_to(AttackLocation.global_position)
	if !in_line_of_sight:
		dir_from_player = _find_line_of_sight(dir_from_player)
	
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
	return squared_distance <= pow(EquippedWeapon.AttackRange, 2.0)
	
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
	
func _find_line_of_sight(dir : Vector2) -> Vector2:
	var start_position = PlayerRef.global_position
	
	var degrees = 10.0
	var step = deg_to_rad(degrees)
	var amount = (360.0 / degrees) - 1
	
	for index in amount:
		var current_angle = index * step
		var current_dir = dir.rotated(current_angle)
	
		var end_position = start_position + current_dir * MinMoveRange
		var query = PhysicsRayQueryParameters2D.create(start_position, end_position)
		query.exclude = [self, PlayerRef]
		query.collide_with_areas = true
		query.collide_with_bodies = true
		query.hit_from_inside = true
		
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(query)
		
		if result.is_empty():
			return current_dir
			
	return dir
	
func _update_weapon() -> void:
	if EquippedWeapon:
		EquippedWeapon._update_multipliers(_get_multipliers())
	
static func _get_multipliers() -> CharacterMultipliers:
	var result = Multipliers
	if AdditionalMultipliers:
		result._add(AdditionalMultipliers)
	return result
	
static func _override_multipliers(new_multipliers : CharacterMultipliers) -> void:
	Multipliers = new_multipliers
