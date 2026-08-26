extends Level

class_name BattleLevel

var enemyAmount : int = 0
var LevelMultiplier : float = 1.0

func _ready() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy : Enemy in enemies:
		enemy.OnDied.connect(_on_enemy_died)
		enemy._update_multipliers(LevelMultiplier)
		enemyAmount += 1
	
func _on_enemy_died() -> void:
	enemyAmount -= 1
	if enemyAmount <= 0:
		_on_win.emit()
