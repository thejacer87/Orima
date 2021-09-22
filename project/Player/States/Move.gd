extends PlayerState

const FLOOR := Vector2.UP
const SPEED_WALK := 7.0 * Globals.UNIT_SIZE
const SPEED_RUN := 15.0 * Globals.UNIT_SIZE
const MAX_FALL_SPEED := 300



var gravity
var velocity := Vector2.ZERO
var max_jump_velocity
var min_jump_velocity
var max_jump_height := 4.5 * Globals.UNIT_SIZE
var min_jump_height := 1.25 * Globals.UNIT_SIZE
var speed := SPEED_WALK
var snap = Vector2.DOWN * 8
var jump_duration := .5
var is_running := false
var is_jumping := false


func _ready() -> void:
	yield(owner, "ready")
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)


func physics_process(delta: float) -> void:
	var direction = get_direction()
	var state = "Move/Walk" if speed == SPEED_WALK else "Move/Run"
	if direction.x > 0:
		velocity.x = min(velocity.x + 100, speed)
		_state_machine.transition_to(state)
	elif direction.x < 0:
		velocity.x = max(velocity.x - 100, -speed)
		_state_machine.transition_to(state)
	else:
		velocity.x = 0
		_state_machine.transition_to("Move/Idle")

	apply_velocity(delta)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Jump")
	if event.is_action_pressed("run"):
		speed = SPEED_RUN
	if event.is_action_released("run"):
		speed = SPEED_WALK


func apply_velocity(delta: float) -> void:
	velocity.y = min(velocity.y + gravity * delta, MAX_FALL_SPEED)
#	velocity = player.move_and_slide_with_snap(velocity, snap, FLOOR)
	velocity = player.move_and_slide(velocity, FLOOR)


func get_direction() -> Vector2:
	return Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), 0)


