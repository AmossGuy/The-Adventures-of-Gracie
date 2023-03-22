extends Container

@export var label: String
@export var action: String

func _ready() -> void:
	update_text()

func update_text() -> void:
	var event := InputMap.action_get_events(action)[0]
	var key := OS.get_keycode_string(event.physical_keycode)
	$Button.text = "{0}: {1}".format([label, key])

func _on_button_focus_exited() -> void:
	$Button.button_pressed = false

func _on_button_gui_input(event: InputEvent) -> void:
	if $Button.button_pressed:
		if event is InputEventKey and event.pressed:
			accept_event()
			$Button.button_pressed = false
			
			var a_event := InputMap.action_get_events(action)[0]
			a_event.physical_keycode = event.physical_keycode
			
			update_text()
