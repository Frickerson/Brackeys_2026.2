extends NavigationRegion2D
class_name Level

signal _on_win;
@export var alternativeTimerWin = 0

var enemyAmount: int = 0

func _ready() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		var casted_enemy := enemy as Enemy
		casted_enemy.OnDied.connect(_on_enemy_died)
		enemyAmount += 1
	
func _on_enemy_died() -> void:
	enemyAmount -= 1
	if enemyAmount <= 0:
		_on_win.emit()
