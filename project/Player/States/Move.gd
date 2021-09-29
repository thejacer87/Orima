extends PlayerState

const FLOOR := Vector2.UP
const FLOOR_SNAP := Vector2.DOWN * 8
const SPEED_WALK := 7.0 * Globals.UNIT_SIZE
const SPEED_RUN := 18.0 * Globals.UNIT_SIZE
const MAX_FALL_SPEED := 300


var gravity
var floor_snap
var velocity := Vector2.ZERO
var max_jump_velocity
var max_run_jump_velocity
var min_jump_velocity
var speed := SPEED_WALK
var jump_duration := .5
var idle_friction := 0.2
var friction := 0.02


func _ready() -> void:
	yield(owner, "ready")
	var max_jump_height = 4.5 * Globals.UNIT_SIZE
	floor_snap = FLOOR_SNAP
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	max_run_jump_velocity = -sqrt(2 * gravity * (max_jump_height + Globals.UNIT_SIZE))
	min_jump_velocity = -sqrt(2 * gravity * 1.25 * Globals.UNIT_SIZE)


func physics_process(_delta: float) -> void:
	var direction = get_direction()

	if direction:
		velocity.x = lerp(velocity.x, direction * speed, friction)
		_state_machine.transition_to("Move/Walk" if speed == SPEED_WALK else "Move/Run")
	else:
		velocity.x = lerp(velocity.x, 0, idle_friction)
		_state_machine.transition_to("Move/Idle")

	if velocity.y > 0:
		_state_machine.transition_to("Move/Fall")

	apply_velocity()

	# Hack needed so if the player presses run while in the air. probably a
	# better solution available
	if (Input.is_action_pressed("run")):
		var a = InputEventAction.new()
		a.action = "run"
		a.pressed = true
		Input.parse_input_event(a)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Jump")
	if event.is_action_pressed("run"):
		speed = SPEED_RUN
	if event.is_action_released("run"):
		speed = SPEED_WALK


func apply_velocity() -> void:
	var delta = get_physics_process_delta_time()
	velocity.y = min(velocity.y + gravity * delta, MAX_FALL_SPEED)
	velocity = player.move_and_slide_with_snap(velocity, floor_snap, FLOOR)
#	velocity = player.move_and_slide(velocity, FLOOR)


func get_direction() -> float:
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

