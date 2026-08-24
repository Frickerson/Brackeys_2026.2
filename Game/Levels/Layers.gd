@tool
extends Node2D

var layers = get_tree().get_nodes_in_group("layers")

@export_tool_button("clear all layers") var clear_all_layers_button = clear_all_layers

func clear_all_layers():
	if Engine.is_editor_hint():
		for layer in layers:
			assert(layer is TileMapLayer, "There is a node in the group layers that is NOT a TileMapLayer")
			layer.clear()
	
