extends Area2D

@export var spawn: Node2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var thingy := get_tree().current_scene
		CheckpointHackPleaseRefactor.player_start = thingy.get_path_to(spawn)
