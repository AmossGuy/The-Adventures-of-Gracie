extends CharacterBody2D

const GRAVITY: float = 400.0
const WALK_SPEED: float = 80.0
const JUMP_FORCE: float = 210.0
const JUMP_RELEASE_MULTIPLIER: float = 0.5
const JUMP_BUFFER_TIME: float = 0.2
const JUMP_COYOTE_TIME: float = 0.2
const THROW_POWER: float = 100.0
const INVULNERABILITY_TIME: float = 1.0
const FLASH_INTERVAL: float = 0.1
const KNOCKBACK_FORCE_H: float = 50.0
const KNOCKBACK_FORCE_V: float = 100.0
const OOF_BOUNCE: float = 100.0

enum State {
	GROUND,
	JUMP,
	FALL,
	HURT,
	OOFED,
	VICTORY,
}

var state: int = State.GROUND
var jump_buffer_timer: float = 0.0
var jump_coyote_timer: float = 0.0
var invulnerability_timer: float = 0.0

func _ready() -> void:
	var level_manager := get_tree().current_scene
	var camera := $Camera2D
	camera.limit_left = level_manager.camera_left
	camera.limit_right = level_manager.camera_right
	camera.limit_top = level_manager.camera_top
	camera.limit_bottom = level_manager.camera_bottom

func _physics_process(delta: float) -> void:
	var sudoku := false
	if Input.is_action_just_pressed("debug_sudoku"):
		sudoku = true
	
	if invulnerability_timer > 0:
		var interval := FLASH_INTERVAL
		if invulnerability_timer <= INVULNERABILITY_TIME / 5:
			interval /= 2
		$sprite.visible = fmod(invulnerability_timer, interval * 2) >= interval
		invulnerability_timer -= delta
		invulnerability_timer = max(invulnerability_timer, 0)
	elif not state in [State.HURT, State.OOFED]:
		$sprite.visible = true
		if %hitbox.has_overlapping_areas() or sudoku:
			velocity.x = -$sprite.scale.x * KNOCKBACK_FORCE_H
			velocity.y = -KNOCKBACK_FORCE_V
			$health.health -= 1
			if sudoku:
				$health.health = 0
			if $health.health <= 0:
				velocity.y *= 1.5
				state = State.OOFED
				var camera: Node = $Camera2D
				var c_trans: Transform2D = camera.global_transform
				remove_child(camera)
				get_parent().add_child(camera)
				camera.global_transform = c_trans
			else:
				invulnerability_timer = INVULNERABILITY_TIME
				state = State.HURT
	
	var grab_area: Area2D = get_node("%grab_area")
	var frisbee_sprite: Node = $sprite/%frisbee_sprite
	
	for frisbee in get_tree().get_nodes_in_group("frisbee"):
		if abs(frisbee.velocity.x) < 40 and grab_area.overlaps_body(frisbee):
			frisbee.queue_free()
			$attacks.f_ammo += 1
			frisbee_sprite.visible = $attacks.selection == 1 and $attacks.f_ammo > 0
	
	if Input.is_action_just_pressed("switch"):
		if $attacks.selection == 0:
			$attacks.selection = 1
		else:
			$attacks.selection = 0
		frisbee_sprite.visible = $attacks.selection == 1 and $attacks.f_ammo > 0
	
	if Input.is_action_just_pressed("attack"):
		if $attacks.selection == 1 and $attacks.f_ammo > 0:
			$attacks.f_ammo -= 1
			var frisbee: Node2D = load("res://objects/frisbee.tscn").instantiate()
			frisbee.global_position = frisbee_sprite.global_position + Vector2(0, 2)
			frisbee.velocity = Vector2(THROW_POWER * $sprite.scale.x, -THROW_POWER)
			get_parent().add_child(frisbee)
		elif $attacks.selection == 0:
			$sprite/%AnimationPlayer.stop()
			$sprite/%AnimationPlayer.play("bite")
		
		frisbee_sprite.visible = $attacks.selection == 1 and $attacks.f_ammo > 0
	
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
	
	if state in [State.GROUND, State.JUMP, State.FALL]:
		var hor_input := -float(Input.is_action_pressed("left")) + float(Input.is_action_pressed("right"))
		velocity.x = hor_input * WALK_SPEED
	elif state == State.VICTORY:
		velocity.x = 0
	
	velocity += delta * Vector2.DOWN * GRAVITY
	
	if state in [State.GROUND, State.JUMP, State.FALL]:
		if velocity.x < 0:
			$sprite.scale.x = -1
		elif velocity.x > 0:
			$sprite.scale.x = 1
	
	move_and_slide()

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider().is_in_group("trampoline"):
			velocity.y = -300 if Input.is_action_pressed("jump") else -150
	
	if state == State.HURT and is_on_floor():
		state = State.GROUND
	if state == State.OOFED and is_on_floor():
		velocity.y = -OOF_BOUNCE
		collision_layer = 0
		collision_mask = 0
	
	if state == State.OOFED:
		if not $VisibleOnScreenNotifier2D.is_on_screen():
			get_tree().create_timer(1.5, false).timeout.connect(
				get_tree().current_scene.restart_from_checkpoint
			)
			queue_free()
