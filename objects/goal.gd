extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.state = body.State.VICTORY
		$flag.region_rect.position.y = 0
		$Area2D.queue_free()
		
		var victory_screen := preload("res://misc/victory_screen.tscn").instantiate()
		get_tree().current_scene.get_node("hud").add_child(victory_screen)
