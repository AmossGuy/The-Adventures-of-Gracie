extends Button

func _init() -> void:
	set_process(true)

func _process(_delta: float) -> void:
	if get_tree().root.mode == Window.MODE_FULLSCREEN:
		text = "Fullscreen: On"
	else:
		text = "Fullscreen: Off"
