extends Node

var scene: String = ""
var player_start: NodePath = ""

func _process(_delta: float) -> void:
	var tree_scene := get_tree().current_scene
	var current_scene := tree_scene.scene_file_path if tree_scene != null else ""
	
	if current_scene != scene:
		scene = current_scene
		player_start = ""
