extends CanvasLayer

func _on_health_health_changed(_old: float, new: float) -> void:
	$health_bar.value = new
