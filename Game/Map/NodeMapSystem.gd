extends Node2D

@export var StarterNode : BaseNode

var CurrentNode : BaseNode = null
var current_floor = 0

func _ready() -> void:
	current_floor = 0
	if StarterNode:
		CurrentNode = StarterNode
		CurrentNode.disabled = false
		CurrentNode.pressed.connect(on_node_pressed.bind(CurrentNode))

func on_node_pressed(node: BaseNode):
	CurrentNode.disabled = true
	for child in CurrentNode.ChildNodes:
		child.disabled = true
		child.pressed.disconnect(on_node_pressed.bind(child))
		
	CurrentNode = node
	var scene = node.get_scene().instantiate() as Level
	scene._on_win.connect(on_win);
	%CurrentScene.add_child(scene)
	%Map.visible = false

func on_win(scene: Level):
	print("winning")
	CurrentNode.disabled = true
	if CurrentNode.ChildNodes.is_empty(): 
		get_tree().quit()
	else:
		for child in CurrentNode.ChildNodes:
			child.disabled = false
			child.pressed.connect(on_node_pressed.bind(child))

		%CurrentScene.remove_child(scene)
		%Map.visible = true
