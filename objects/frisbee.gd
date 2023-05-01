extends CharacterBody2D

const GRAVITY: float = 400.0
const FRICTION: float = 100.0
const BOUNCE_MULTIPLIER: float = 0.8
const BOUNCE_MIN: float = 50.0
const HARMFUL_SPEED: float = 70.0

func _physics_process(delta: float) -> void:
	velocity += delta * Vector2.DOWN * GRAVITY
	
	if is_on_floor() and not velocity.y < 0: # the latter bit is so we don’t have friction for one frame when bouncing on the floor.
		var ground_speed: float = abs(velocity.x)
		
		ground_speed -= delta * FRICTION
		ground_speed = max(ground_speed, 0)
		
		velocity.x = ground_speed * sign(velocity.x)
	
	var prev_velocity := velocity
	move_and_slide()
	
	var collision := get_last_slide_collision()
	if collision != null and prev_velocity.length() >= BOUNCE_MIN:
		velocity = prev_velocity.bounce(collision.get_normal()) * BOUNCE_MULTIPLIER
	
	%hurtbox_shape.set_deferred("disabled", not (velocity.length_squared() >= HARMFUL_SPEED ** 2))
