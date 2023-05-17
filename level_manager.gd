extends Node2D

var player_start: NodePath = ""

# dog handles applying these currently
@export var camera_left: int = -10000000
@export var camera_right: int = 10000000
@export var camera_top: int = -10000000
@export var camera_bottom: int = 10000000

func _ready() -> void:
	var kkkkkkkkk := CheckpointHackPleaseRefactor.player_start
	if str(kkkkkkkkk) != "":
		player_start = kkkkkkkkk
	var player_start_node := get_node(player_start)
	if is_instance_valid(player_start_node):
		var player: Node2D = player_start_node.spawn_player()
		var hud := preload("res://hud.tscn").instantiate()
		add_child(hud)
		player.get_node("health").connect("health_changed", hud.update_health)
		player.get_node("health").spaghetti()
		player.get_node("attacks").connect("attackstatus_changed", hud.update_attackstatus)
		player.get_node("attacks").spaghetti()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		add_child(preload("res://misc/pause_menu.tscn").instantiate())

func restart_from_checkpoint() -> void:
	var tree := get_tree()
	tree.reload_current_scene()
#	tree.current_scene.player_start = self.player_start
	var s := player_start
	var AAAAAA := func():
		tree.current_scene.player_start = s
	AAAAAA.call_deferred()

func display_checkpoint_popup() -> void:
	var popup := preload("res://misc/checkpoint_popup.tscn").instantiate()
	$hud.add_child(popup)
