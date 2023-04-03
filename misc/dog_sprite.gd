extends Node2D

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"bite_windup":
			$AnimationPlayer.play("bite")
		"bite":
			$AnimationPlayer.play("stand")

func spawn_bite_hitbox() -> void:
	%bite_hitbox.create_instance()
