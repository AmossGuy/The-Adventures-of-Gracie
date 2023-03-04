extends Node

signal health_changed(old, new)

export var max_health: float = 10
onready var health: float = max_health setget health_set

func health_set(value: float) -> void:
	var old_health := health
	health = value
	emit_signal("health_changed", old_health, health)
