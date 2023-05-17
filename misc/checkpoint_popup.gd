extends Control

@onready var a_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var exit := false

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if not exit:
		timer.start()
	else:
		queue_free()

func _on_timer_timeout() -> void:
	exit = true
	a_player.play_backwards()
