extends KinematicBody2D

const GRAVITY: float = 400.0
const FRICTION: float = 100.0
const BOUNCE_MULTIPLIER: float = 0.8
const BOUNCE_MIN: float = 50.0

var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:	
	velocity += delta * Vector2.DOWN * GRAVITY
	
	if is_on_floor() and not velocity.y < 0: # the latter bit is so we don’t have friction for one frame when bouncing on the floor.
		var ground_speed := abs(velocity.x)
		
		ground_speed -= delta * FRICTION
		ground_speed = max(ground_speed, 0)
		
		velocity.x = ground_speed * sign(velocity.x)
	
	var prev_velocity := velocity
	velocity = move_and_slide(velocity, Vector2.UP, false)
	
	if (is_on_floor() or is_on_ceiling()) and abs(prev_velocity.y) >= BOUNCE_MIN:
		velocity.y = -prev_velocity.y * BOUNCE_MULTIPLIER
		
	if is_on_wall() and abs(prev_velocity.x) >= BOUNCE_MIN:
		velocity.x = -prev_velocity.x * BOUNCE_MULTIPLIER
