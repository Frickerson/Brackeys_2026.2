extends Level

class_name BattleLevel

var enemyAmount : int = 0
var LevelMultiplier : CharacterMultipliers = null

func _ready() -> void:
	if LevelMultiplier:
		Enemy._override_multipliers(LevelMultiplier)
		get_tree().call_group("Enemy", "_update_multipliers")

	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy : Enemy in enemies:
		enemy.OnDied.connect(_on_enemy_died)
		enemyAmount += 1

func _on_enemy_died() -> void:
	enemyAmount -= 1
	if enemyAmount <= 0:
		$Exit.enable()
		$Exit.body_entered.connect(_on_exit_reached)
		
func _on_exit_reached(body: Node2D) -> void:
	print("entered")
	if body is Player:
		_on_win.emit()

func _finish() -> void:
	Player._add_multipliers(CharacterMultipliers._get_random_multiplier(0.2))
