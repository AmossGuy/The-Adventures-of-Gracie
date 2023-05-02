@tool
extends Node2D

@export var start: bool = false

func _ready() -> void:
	if Engine.is_editor_hint():
		add_child(load("res://misc/dog_sprite.tscn").instantiate())
	
	if not Engine.is_editor_hint():
		if start:
			get_tree().current_scene.player_start = self

func spawn_player() -> void:
	var player := preload("res://objects/dog.tscn").instantiate()
	get_tree().current_scene.add_child(player)
	player.global_transform = self.global_transform
