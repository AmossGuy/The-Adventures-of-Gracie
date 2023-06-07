extends CharacterBody2D

const GRAVITY: float = 400.0
const WALK_SPEED: float = 40.0

const INVULNERABILITY_TIME: float = 1.0
const FLASH_INTERVAL: float = 0.1

const DETECTION_RADIUS: float = 16 * 6
const TRY_ATTACK_RADIUS: float = 16 * 2
const ATTACK_COOLDOWN: float = 1

const BORE_RADIUS: float = 16 * 8

enum AiState {
	IDLE,
	CHASE,
}

var ai_state: int = AiState.IDLE
var health: float = 3
var invulnerability_timer: float = 0
var attack_cooldown: float = ATTACK_COOLDOWN

@onready var home: Vector2 = global_position

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
	
	var closest: Node2D = null
	var d := INF
	for node in get_tree().get_nodes_in_group("player"):
		var node_d: float = node.position.distance_squared_to(self.position)
		if node_d < d:
			closest = node
			d = node_d
	
	if closest != null:
		var distance := sqrt(d)
		
		if ai_state == AiState.IDLE:
			if distance <= DETECTION_RADIUS:
				ai_state = AiState.CHASE
		elif ai_state == AiState.CHASE:
			if distance > BORE_RADIUS:
				ai_state = AiState.IDLE
			elif attack_cooldown > 0:
				attack_cooldown -= delta
			else:
				if distance <= TRY_ATTACK_RADIUS:
					%AnimationPlayer.stop()
					%AnimationPlayer.play("bite_windup")
					attack_cooldown = ATTACK_COOLDOWN
	else:
		ai_state = AiState.IDLE
	
	if ai_state == AiState.CHASE and %AnimationPlayer.current_animation == "stand":
		velocity.x = WALK_SPEED * (-1 if closest.global_position.x < global_position.x else 1)
	elif ai_state == AiState.IDLE and %AnimationPlayer.current_animation == "stand":
		velocity.x = WALK_SPEED * (-1 if home.x < global_position.x else 1) if abs(home.x - global_position.x) > 8 else 0.0
	else:
		velocity.x = 0
	
	velocity += delta * Vector2.DOWN * GRAVITY
	
	if true:
		if velocity.x < 0:
			$sprite.scale.x = -1
		elif velocity.x > 0:
			$sprite.scale.x = 1
		else:
			if is_instance_valid(closest):
				$sprite.scale.x = (-1 if closest.global_position.x < global_position.x else 1)
	
	if not %edge_raycast.is_colliding():
		velocity.x = 0
	
	move_and_slide()
