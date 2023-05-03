extends Node

signal health_changed(health, max_health)

@export var max_health: float = 10
@onready var health: float = max_health : set = health_set

func spaghetti() -> void:
	emit_signal("health_changed", health, max_health)

func health_set(value: float) -> void:
	health = value
	emit_signal("health_changed", health, max_health)
