extends Control

var accept_input := false

func _ready() -> void:
	var event := InputMap.action_get_events("jump")[0]
	%prompt_label.text = %prompt_label.text.format({
		"key": OS.get_keycode_string(event.physical_keycode),
	})

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	accept_input = true

func _process(_delta: float) -> void:
	if accept_input:
		if Input.is_action_just_pressed("jump"):
			get_tree().change_scene_to_file("res://menu.tscn")
