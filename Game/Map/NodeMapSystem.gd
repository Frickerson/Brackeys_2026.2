extends Node2D

@export var StarterNode : BaseNode
var mapSong :OvaniSong = preload("res://Game/Sound/Music/MapSong/MapSong.tres")
@export var mouseCursor: Texture2D = preload("res://Game/Assets/Sprites/tile_0027.png")

var CurrentNode : BaseNode = null
var current_floor = 0

func _ready() -> void:
	var image = mouseCursor.get_image()
	image.resize(mouseCursor.get_width() * 2, mouseCursor.get_height() * 2)
	Input.set_custom_mouse_cursor(image)
	current_floor = 0
	$OvaniPlayer.PlaySongNow(mapSong, 1)
	if StarterNode:
		CurrentNode = StarterNode
		CurrentNode.disabled = false
		CurrentNode.pressed.connect(on_node_pressed.bind(CurrentNode))

func on_node_pressed(node: BaseNode):
	CurrentNode.disabled = true
	for child in CurrentNode.ChildNodes:
		child.disabled = true
		if child.pressed.is_connected(on_node_pressed.bind(child)):
			child.pressed.disconnect(on_node_pressed.bind(child))
		
	CurrentNode = node
	var scene = CurrentNode._get_loaded_level()
	scene._on_win.connect(on_win);
	$OvaniPlayer.PlaySongNow((scene as Level).Song, 1)
	$OvaniPlayer.FadeIntensity(1.0 - (Player.Trust/100), 1)
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
		$OvaniPlayer.PlaySongNow(mapSong, 1)
