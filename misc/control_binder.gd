extends Container

const actions: Dictionary = {
	"left": "Left", "right": "Right", "up": "Up", "down": "Down",
	"jump": "Jump", "attack": "Attack", "switch": "Switch attacks",
}

func _ready() -> void:
	for action in actions:
		var entry = preload("res://misc/control_binder_entry.tscn").instantiate()
		entry.action = action
		entry.label = actions[action]
		add_child(entry)
	
	var resetall_button = Button.new()
	resetall_button.text = "Reset all"
	resetall_button.disabled = true
	add_child(resetall_button)
