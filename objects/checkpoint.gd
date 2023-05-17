extends Area2D

@export var spawn: Node2D

func _on_body_entered(body: Node2D) -> void:
	var ch := CheckpointHackPleaseRefactor
	
	if body.is_in_group("player"):
		var new_start := get_tree().current_scene.get_path_to(spawn)
		if ch.player_start != new_start:
			ch.player_start = new_start
			get_tree().current_scene.display_checkpoint_popup()
