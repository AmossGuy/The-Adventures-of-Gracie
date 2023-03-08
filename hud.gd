extends CanvasLayer

onready var dots: Array = [$health_dot]

func update(health: float, max_health: float) -> void:
	if max_health != dots.size():
		for i in range(1, dots.size()):
			dots[i].queue_free()
		dots = [dots[0]]
		for i in max_health - 1:
			var copy: Node2D = dots[0].duplicate()
			copy.position.x += (i + 1) * 12
			dots.append(copy)
			dots[0].get_parent().add_child(copy)
	
	for i in dots.size():
		# i am struck by the realization that this is not exactly self-documenting.
		dots[i].frame = (2 if health < i + 1 else 0) if health > i else 1
