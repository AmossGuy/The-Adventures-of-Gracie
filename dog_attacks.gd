extends Node

signal attackstatus_changed(selection, f_ammo)

var selection: int = 0 : set = selection_set
var f_ammo: int = 0 : set = f_ammo_set

func _ready() -> void:
	emit_signal("attackstatus_changed", selection, f_ammo)

func selection_set(value: int) -> void:
	selection = value
	emit_signal("attackstatus_changed", selection, f_ammo)

func f_ammo_set(value: int) -> void:
	f_ammo = value
	emit_signal("attackstatus_changed", selection, f_ammo)
