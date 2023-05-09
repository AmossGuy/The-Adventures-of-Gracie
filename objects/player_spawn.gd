@tool
extends Node2D

@export var start: bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		add_child(load("res://misc/dog_sprite.tscn").instantiate())
	
	if not Engine.is_editor_hint():
		if start:
			var thingy := get_tree().current_scene
			if str(thingy.player_start) == "":
				thingy.player_start = thingy.get_path_to(self)

func spawn_player() -> Node2D:
	var player := preload("res://objects/dog.tscn").instantiate()
	get_tree().current_scene.add_child(player)
	player.global_transform = self.global_transform
	return player
