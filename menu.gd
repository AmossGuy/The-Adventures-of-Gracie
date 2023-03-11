extends Node2D

@onready var menu_container: BoxContainer = %menu_container

func _ready() -> void:
	setup_main_menu()

func start_new_menu(title: String) -> void:
	for node in menu_container.get_children():
		node.queue_free()
	
	var header := Label.new()
	header.text = title
	menu_container.add_child(header)
	
	var spacer := Control.new()
	spacer.custom_minimum_size.y = 8
	menu_container.add_child(spacer)

func add_button(label: String, action: Callable = func(): pass) -> void:
	var button := Button.new()
	button.text = label
	button.pressed.connect(action)
	menu_container.add_child(button)

func setup_main_menu() -> void:
	start_new_menu("MAIN MENU")
	add_button("Level Select", setup_level_select)
	add_button("Quit", func(): get_tree().quit())

func setup_level_select() -> void:
	start_new_menu("LEVEL SELECT")
	add_button("Back", setup_main_menu)
	add_button("Test Level", func(): get_tree().change_scene_to_file("res://levels/test.tscn"))
