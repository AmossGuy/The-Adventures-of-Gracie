extends KinematicBody2D

export var patrol: bool = false

const GRAVITY: float = 400.0
const WALK_SPEED: float = 40.0
const EDGE_COOLDOWN: float = 0.1

var velocity: Vector2 = Vector2.ZERO
var direction: float = 1
var edge_cooldown: float = 0

func _physics_process(delta: float) -> void:
	if patrol:
		velocity.x = WALK_SPEED * direction
	
	velocity += delta * Vector2.DOWN * GRAVITY
	
	if velocity.x < 0:
		$Sprite.scale.x = -1
	elif velocity.x > 0:
		$Sprite.scale.x = 1
	
	var snap := Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
	if edge_cooldown > 0:
		edge_cooldown -= delta
	else:
		if patrol and (is_on_wall() or (is_on_floor() and not $edge_raycast.is_colliding())):
			direction = -direction
			edge_cooldown = EDGE_COOLDOWN
