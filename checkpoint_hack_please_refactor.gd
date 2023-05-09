extends Node

var scene: String = ""
var player_start: NodePath = ""

func _process(_delta: float) -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	if current_scene != scene:
		scene = current_scene
		player_start = ""
