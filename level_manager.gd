extends Node2D

var player_start: Node2D = null

# dog handles applying these currently
@export var camera_left: int = -10000000
@export var camera_right: int = 10000000
@export var camera_top: int = -10000000
@export var camera_bottom: int = 10000000

func _ready() -> void:
	if is_instance_valid(player_start):
		player_start.spawn_player()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		add_child(preload("res://misc/pause_menu.tscn").instantiate())
