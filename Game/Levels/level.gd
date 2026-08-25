extends NavigationRegion2D
class_name Level

signal _on_win;
@export var alternativeTimerWin = 5

var enemyAmount: int

func _ready() -> void:
	enemyAmount = get_tree().get_node_count_in_group("Enemy")
	if alternativeTimerWin > 0:
		$AlternativeWin.start(alternativeTimerWin)


func _on_alternative_win_timeout() -> void:
	print("timeout")
	_on_win.emit(self);
	pass # Replace with function body.
