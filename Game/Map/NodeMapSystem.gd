extends Node2D

@export var StarterNode : BaseNode
var mapSong :OvaniSong = preload("res://Game/Sound/Music/MapSong/MapSong.tres")

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
	var scene = CurrentNode._get_loaded_level()
	scene._on_win.connect(on_win);
	$OvaniPlayer.PlaySongNow((scene as Level).Song)
	$OvaniPlayer.FadeIntensity(Player.Distrust/100, 1)
	%CurrentScene.add_child(scene)
	%Map.visible = false

func on_win():
	var scene = CurrentNode._get_loaded_level()
	scene._on_win.disconnect(on_win)
	scene.queue_free()
	
	CurrentNode.disabled = true
	if CurrentNode.ChildNodes.is_empty(): 
		get_tree().quit()
	else:
		for child in CurrentNode.ChildNodes:
			child.disabled = false
			child.pressed.connect(on_node_pressed.bind(child))

		%Map.visible = true
		$OvaniPlayer.PlaySongNow(mapSong)
