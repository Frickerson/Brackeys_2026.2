extends CharacterBase

class_name Enemy

@export_group("Weapon")
@export var UseAmmo : bool = false

@export_group("Movement")
@export var MinMoveRange : float = 100.0:
	get:
		var multipliers = _get_multipliers()
		if multipliers:
			return MinMoveRange * multipliers.AttackRangeMultiplier
		return MinMoveRange
@export var MaxMoveRange : float = 300.0
@export var AvoidanceRadius : float = 30.0

@export_group("")
@export var NavigationAgent : NavigationAgent2D
@export var RayCast : RayCast2D

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

@export var dropInfo : DropInfo
var drop: Drop = preload("res://Game/Objects/Drops/Drop.tscn").instantiate();
@onready var LevelRoot = get_tree().get_first_node_in_group("LevelRoot")

static var Multipliers : CharacterMultipliers
static var AdditionalMultipliers : CharacterMultipliers

var SpawnPosition : Vector2

func _ready() -> void:
	if !Multipliers && DefaultMultipliers:
		Multipliers = DefaultMultipliers
	
	super._ready()
	
	if EquippedWeapon != null:
		EquippedWeapon._toggle_uses_ammo(UseAmmo)
		
	RayCast.add_exception(PlayerRef)
	NavigationAgent.radius = AvoidanceRadius
	
	SpawnPosition = global_position

func _physics_process(_delta: float) -> void:
	if Dying:
		return
	
	if PlayerRef == null:
		EquippedWeapon._toggle_attack(false)
		NavigationAgent.set_velocity(Vector2.ZERO)
		return
	
	if PlayerRef.Respawning:
		EquippedWeapon._toggle_attack(false)
		_move_to(SpawnPosition)
		_rotate_towards(SpawnPosition)
		return

	var player_position = PlayerRef.global_position
	var in_move_range = _in_move_range(player_position)
	var in_attack_range = _in_attack_range(player_position)
	var in_line_of_sight = _in_line_of_sight(player_position)
	_calculate_arrow(_delta)
	
	if in_move_range:
		_move_towards_player(player_position, in_line_of_sight)
	
	if in_move_range || (in_attack_range && in_line_of_sight):
		_rotate_towards(player_position)

	var enable_attack = in_attack_range && in_line_of_sight
	EquippedWeapon._toggle_attack(enable_attack)
	
func _move_towards_player(player_position : Vector2, in_line_of_sight : bool) -> void:
	var dir_from_player = player_position.direction_to(AttackLocation.global_position)
	if !in_line_of_sight:
		dir_from_player = _find_line_of_sight(dir_from_player)
	
	var target_position = player_position + dir_from_player * MinMoveRange
	_move_to(target_position)
	
func _move_to(new_position : Vector2) -> void:
	NavigationAgent.target_position = new_position
	if NavigationAgent.is_navigation_finished():
		return
	
	var next_position = NavigationAgent.get_next_path_position()
	var dir = global_position.direction_to(next_position)
	NavigationAgent.set_velocity(dir * MoveSpeed)
	
func _rotate_towards(rotate_position : Vector2) -> void:
	if rotate_position.distance_squared_to(global_position) <= 100.0:
		return
		
	var direction = AttackLocation.global_position.direction_to(rotate_position)
	rotation = direction.angle()

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
		
func _on_death():
	if not Dying:
		super._on_death()
		drop._initialize(dropInfo)
		LevelRoot.call_deferred("add_child",drop)
		drop.global_position = global_position

func _calculate_arrow(delta : float):
	var on_screen_offset = Vector2(5, -5)
	var screen_margin = 25
	var smoothing_speed = 4
	
	var target_position = global_position + on_screen_offset
	var viewport_dimensions = get_viewport().get_visible_rect().size
	var screen_coordinates = (target_position - PlayerRef.Camera.get_screen_center_position()) * PlayerRef.Camera.zoom + viewport_dimensions * 0.5
	var screen_inset_rect = get_viewport().get_visible_rect().grow(-screen_margin)
	
	var target_display_position: Vector2
	var target_display_rotation: float
	
	if screen_inset_rect.has_point(screen_coordinates):
		if $Arrow.visible:
			$Arrow.visible = false
	else:
		if not $Arrow.visible:
			$Arrow.visible = true
		var clamped_x = clamp(screen_coordinates.x,screen_margin,viewport_dimensions.x-screen_margin)
		var clamped_y = clamp(screen_coordinates.y,screen_margin,viewport_dimensions.y-screen_margin)
		var clamped_screen_coords = Vector2(clamped_x, clamped_y)
		
		target_display_position = PlayerRef.Camera.get_screen_center_position() + (clamped_screen_coords - viewport_dimensions * 0.5) / PlayerRef.Camera.zoom
		
		var vector_to_target =  target_position - target_display_position 
		target_display_rotation = vector_to_target.angle() + (PI * 0.5)
	
	$Arrow.global_position = lerp($Arrow.global_position, target_display_position, delta*smoothing_speed)
	$Arrow.global_rotation = lerp($Arrow.global_rotation, target_display_rotation, delta*smoothing_speed)
	return
	
static func _get_multipliers() -> CharacterMultipliers:
	var result = Multipliers
	if AdditionalMultipliers:
		result._add(AdditionalMultipliers)
	return result
	
static func _override_multipliers(new_multipliers : CharacterMultipliers) -> void:
	Multipliers = new_multipliers
