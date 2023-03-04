extends KinematicBody2D

const SNAP_DISTANCE: float = 4.0
const GRAVITY: float = 400.0
const WALK_SPEED: float = 80.0
const JUMP_FORCE: float = 210.0
const JUMP_RELEASE_MULTIPLIER: float = 0.5
const JUMP_BUFFER_TIME: float = 0.2
const JUMP_COYOTE_TIME: float = 0.2
const THROW_POWER: float = 100.0
const INVULNERABILITY_TIME: float = 1.0
const FLASH_INTERVAL: float = 0.1

enum State {
	GROUND,
	JUMP,
	FALL,
	OOFED,
}

var state: int = State.GROUND
var velocity: Vector2 = Vector2.ZERO
var jump_buffer_timer: float = 0.0
var jump_coyote_timer: float = 0.0
var invulnerability_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if invulnerability_timer > 0:
		var interval := FLASH_INTERVAL
		if invulnerability_timer <= INVULNERABILITY_TIME / 5:
			interval /= 2
		$Sprite.visible = fmod(invulnerability_timer, interval * 2) >= interval
		invulnerability_timer -= delta
		invulnerability_timer = max(invulnerability_timer, 0)
	else:
		$Sprite.visible = true
		var ow_area: Area2D = get_node("%ow_area")
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if ow_area.overlaps_body(enemy):
				$health.health -= 1
				if $health.health <= 0:
					$Sprite.scale.y = 0.5
					velocity.x = 0
					state = State.OOFED
				else:
					invulnerability_timer = INVULNERABILITY_TIME
				break
	
	if Input.is_action_just_pressed("grab"):
		var grab_area: Area2D = get_node("%grab_area")
		var frisbee_sprite: Node = get_node("%frisbee_sprite")
		
		if not frisbee_sprite.visible:
			for frisbee in get_tree().get_nodes_in_group("frisbee"):
				if grab_area.overlaps_body(frisbee):
					frisbee.queue_free()
					frisbee_sprite.visible = true
					break
		else:
			frisbee_sprite.visible = false
			var frisbee: Node = load("res://objects/frisbee.tscn").instance()
			frisbee.global_position = frisbee_sprite.global_position + Vector2(0, 2)
			frisbee.velocity = Vector2(THROW_POWER * $Sprite.scale.x, -THROW_POWER)
			get_parent().add_child(frisbee)
	
	jump_buffer_timer -= delta
	jump_buffer_timer = max(jump_buffer_timer, 0)
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	
	jump_coyote_timer -= delta
	jump_coyote_timer = max(jump_coyote_timer, 0)
	
	match state:
		State.GROUND:
			if not is_on_floor():
				state = State.FALL
				jump_coyote_timer = JUMP_COYOTE_TIME
			elif jump_buffer_timer > 0:
				jump_buffer_timer = 0
				velocity.y = -JUMP_FORCE
				state = State.JUMP
		State.JUMP:
			if is_on_floor():
				state = State.GROUND
			elif velocity.y >= 0:
				state = State.FALL
			elif not Input.is_action_pressed("jump"):
				velocity.y *= JUMP_RELEASE_MULTIPLIER
				state = State.FALL
		State.FALL:
			if is_on_floor():
				state = State.GROUND
			elif Input.is_action_just_pressed("jump") and jump_coyote_timer > 0:
				jump_coyote_timer = 0
				velocity.y = -JUMP_FORCE
				state = State.JUMP
	
	if state != State.OOFED:
		var hor_input := -float(Input.is_action_pressed("left")) + float(Input.is_action_pressed("right"))
		velocity.x = hor_input * WALK_SPEED
	
	velocity += delta * Vector2.DOWN * GRAVITY
	
	if velocity.x < 0:
		$Sprite.scale.x = -1
	elif velocity.x > 0:
		$Sprite.scale.x = 1
	
	var grounded: bool = state == State.GROUND
	var snap := Vector2.DOWN * SNAP_DISTANCE if grounded else Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, true)
