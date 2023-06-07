extends BoxContainer

@export var pause_menu: bool = false

func _ready() -> void:
	setup_main_menu()

func start_new_menu(title: String) -> void:
	for node in get_children():
		node.queue_free()
	
	var header := Label.new()
	header.text = title
	add_child(header)
	
	add_gap()

func add_gap() -> void:
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 4
	add_child(spacer)

func add_button(label: String, action: Callable = func(): pass) -> Button:
	var button := Button.new()
	button.text = label
	button.pressed.connect(action)
	add_child(button)
	return button

func setup_main_menu() -> void:
	start_new_menu("PAUSED" if pause_menu else "MAIN MENU")
	if pause_menu:
		add_button("Unpause", unpause).grab_focus()
	if not pause_menu:
		add_button("Level Select", setup_level_select).grab_focus()
	add_button("Settings", setup_settings_menu)
	if not pause_menu:
		add_button("Quit", get_tree().quit)
	else:
		add_button("Return to Menu", load_level.bind("res://menu.tscn"))

func setup_level_select() -> void:
	start_new_menu("LEVEL SELECT")
	add_button("Back", setup_main_menu).grab_focus()
	add_button("Basic Test", load_level.bind("res://levels/test.tscn"))
	add_button("Enemy Test", load_level.bind("res://levels/test_enemies.tscn"))
	add_button("Checkpoint Test", load_level.bind("res://levels/test_checkpoints.tscn"))
	add_button("Scribble 1", load_level.bind("res://levels/scribble_1.tscn"))

func load_level(level: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(level)

func setup_settings_menu() -> void:
	start_new_menu("SETTINGS")
	add_button("Back", setup_main_menu).grab_focus()
	add_button("Control Settings", setup_control_menu)
	var fs_b := add_button("", toggle_fullscreen)
	fs_b.set_script(preload("res://misc/fullscreen_button_text.gd"))

func toggle_fullscreen() -> void:
	if get_tree().root.mode == Window.MODE_FULLSCREEN:
		get_tree().root.mode = Window.MODE_WINDOWED
	else:
		get_tree().root.mode = Window.MODE_FULLSCREEN

func setup_control_menu() -> void:
	start_new_menu("CONTROL SETTINGS")
	add_button("Back", setup_settings_menu).grab_focus()
	add_gap()
	add_child(preload("res://misc/control_binder.tscn").instantiate())

func unpause() -> void:
	get_tree().paused = false
	get_parent().queue_free()
