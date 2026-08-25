extends Node2D

@export var nodes: Array[BaseNode]
var current_floor = 0

func _ready() -> void:
	current_floor = 0
	for level in nodes:
		level.pressed.connect(on_node_pressed.bind(level))
		level.disabled = true
	nodes[current_floor].disabled = false

func on_node_pressed(node: BaseNode):
	var scene = node.get_scene().instantiate() as Level
	scene._on_win.connect(on_win);
	%CurrentScene.add_child(scene)
	%Map.visible = false

func on_win(scene: Level):
	print("winning")
	nodes[current_floor].disabled = true
	current_floor += 1
	nodes[current_floor].disabled = false
	%CurrentScene.remove_child(scene)
	%Map.visible = true
