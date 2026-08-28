extends Node2D

@export var StarterNode : BaseNode
var mapSong :OvaniSong = preload("res://Game/Sound/Music/MapSong/MapSong.tres")
@export var mouseCursor: Texture2D = preload("res://Game/Assets/Sprites/tile_0027.png")

var CurrentNode : BaseNode = null
var current_floor = 0
const SongTransitionTime = 0.5

func _ready() -> void:
	setup_cursor()
	current_floor = 0
	$OvaniPlayer.PlaySongNow(mapSong, SongTransitionTime)
	$OvaniPlayer.FadeVolume(-10.0, .5)
	if StarterNode:
		CurrentNode = StarterNode
		CurrentNode.set_enabled(true)
		CurrentNode.get_button().pressed.connect(on_node_pressed.bind(CurrentNode))

func on_node_pressed(node: BaseNode):
	CurrentNode.get_button().disabled = true
	for child in CurrentNode.ChildNodes:
		child.get_button().disabled = true
		if child.get_button().pressed.is_connected(on_node_pressed.bind(child)):
			child.get_button().pressed.disconnect(on_node_pressed.bind(child))
		child.set_enabled(false)
		
		
	CurrentNode = node
	var scene = CurrentNode._get_loaded_level()
	scene._on_win.connect(on_win);
	$OvaniPlayer.PlaySongNow((scene as Level).Song, SongTransitionTime)
	$OvaniPlayer.FadeIntensity(1.0 - (Player.Trust/100), 1)
	%CurrentScene.add_child(scene)
	
	var onPlayerDied = func():
		$OvaniPlayer.FadeIntensity(1-(Player.Trust/100),1)
	
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player:
		player.OnDied.connect(onPlayerDied)
	%Map.visible = false

func on_win():
	var scene = CurrentNode._get_loaded_level()
	scene._on_win.disconnect(on_win)
	scene.queue_free()
	
	CurrentNode.set_cleared()
	if CurrentNode.ChildNodes.is_empty(): 
		get_tree().quit()
	else:
		for child in CurrentNode.ChildNodes:
			child.set_enabled(true)
			child.get_button().pressed.connect(on_node_pressed.bind(child))

		%Map.visible = true
		$OvaniPlayer.PlaySongNow(mapSong, SongTransitionTime)

func setup_cursor():
	var image = mouseCursor.get_image()
	image.resize(mouseCursor.get_width() * 2, mouseCursor.get_height() * 2)
	Input.set_custom_mouse_cursor(image)
