extends Node2D

@export var enemy: bool = false

func _ready() -> void:
	if enemy:
		$Sprite2D.material.set_shader_parameter("palette", randi_range(0, 3))
	
	$AnimationPlayer.play("stand")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"bite_windup":
			$AnimationPlayer.play("bite")
		"bite":
			$AnimationPlayer.play("stand")

func spawn_bite_hitbox() -> void:
	var bite_hitbox: Node = %bite_hitbox.create_instance()
	if enemy:
		var stupid: CollisionShape2D = bite_hitbox.get_node("CollisionShape2D")
		var shape := RectangleShape2D.new()
		shape.size = Vector2(8, 8)
		stupid.shape = shape
