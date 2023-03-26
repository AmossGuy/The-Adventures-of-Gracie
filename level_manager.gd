extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		get_tree().paused = true
		add_child(preload("res://misc/pause_menu.tscn").instantiate())
