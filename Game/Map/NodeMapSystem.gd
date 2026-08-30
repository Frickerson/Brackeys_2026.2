extends Node2D

@export var StarterNode : BaseNode
var mapSong :OvaniSong = preload("res://Game/Sound/Music/MapSong/MapSong.tres")
@export var mouseCursor: Texture2D = preload("res://Game/Assets/Sprites/tile_0027.png")

var CurrentNode : BaseNode = null
var current_floor = 0
const SongTransitionTime = 0.5
const LoseScreen: PackedScene = preload("res://Game/UI/Lose/LoseScreen.tscn")
const WinScreen: PackedScene = preload("res://Game/UI/Win/WinScreen.tscn")
@onready var pauseMenu: PauseMenu = $CanvasLayer/PauseMenu

func _ready() -> void:
	setup_cursor()
	current_floor = 0
	$OvaniPlayer.PlaySongNow(mapSong, SongTransitionTime)
	$OvaniPlayer.FadeVolume(-10.0, .5)
	$Control/Map/MarginContainer/HBoxContainer/ScrollContainer.scroll_vertical = $Control/Map/MarginContainer/HBoxContainer/ScrollContainer.get_v_scroll_bar().max_value
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
	
	var trustDepleted = func():
		_reset_player()
		get_tree().call_deferred("change_scene_to_packed", LoseScreen)
	
	var player = get_tree().get_first_node_in_group("Player") as Player
	if player:
		player.OnDied.connect(onPlayerDied)
		player.TrustDepleted.connect(trustDepleted)
	$Control.visible = false

func on_win():
	var scene = CurrentNode._get_loaded_level()
	scene._on_win.disconnect(on_win)
	scene._finish()
	scene.queue_free()
	
	CurrentNode.set_cleared()
	if CurrentNode.ChildNodes.is_empty(): 
		_reset_player()
		get_tree().call_deferred("change_scene_to_packed", WinScreen)
	else:
		for child in CurrentNode.ChildNodes:
			child.set_enabled(true)
			child.get_button().pressed.connect(on_node_pressed.bind(child))

		$Control.visible = true
		$OvaniPlayer.PlaySongNow(mapSong, SongTransitionTime)
		
func _reset_player() -> void:
	Player.Multipliers = CharacterMultipliers.get_default()
	Player.HealthRatio = 1.0
	Player.Gold = 100
	Player.Trust = 100
	Player.Relics = []

func setup_cursor():
	var image = mouseCursor.get_image()
	image.resize(mouseCursor.get_width() * 2, mouseCursor.get_height() * 2)
	Input.set_custom_mouse_cursor(image)
