extends CharacterBody2D

const INVULNERABILITY_TIME: float = 1.0
const FLASH_INTERVAL: float = 0.1

enum AiState {
	IDLE,
}

var ai_state: int = AiState.IDLE
var health: float = 3
var invulnerability_timer: float = 0

func _physics_process(delta: float) -> void:
	if invulnerability_timer > 0:
		var interval := FLASH_INTERVAL
		if invulnerability_timer <= INVULNERABILITY_TIME / 5:
			interval /= 2
		$sprite.visible = fmod(invulnerability_timer, interval * 2) >= interval
		invulnerability_timer -= delta
		invulnerability_timer = max(invulnerability_timer, 0)
	else:
		$sprite.visible = true
		if %hitbox.has_overlapping_areas():
			invulnerability_timer = INVULNERABILITY_TIME
			health -= 1
			if health <= 0:
				queue_free()
