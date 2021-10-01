extends PlayerState

const FLOOR := Vector2.UP
const FLOOR_SNAP := Vector2.DOWN * 8
const SPEED_WALK := 6 * Globals.UNIT_SIZE
const SPEED_RUN := 10 * Globals.UNIT_SIZE
#const SPEED_WALK := 0x1900 / Globals.UNIT_SIZE / 16
#const SPEED_RUN := 0x2900 / Globals.UNIT_SIZE / 16
const MAX_FALL_SPEED := 300


onready var speed := SPEED_WALK
onready var velocity := Vector2.ZERO
onready var friction := 0.02
onready var jump_duration := 0.5
onready var deceleration_idle := 0.2
onready var deceleration_skid := 0.02
onready var acceleration_walk := 0.015
onready var acceleration_run := 0.0225

var gravity
var floor_snap
var max_jump_velocity
var max_run_jump_velocity
var min_jump_velocity


func _ready() -> void:
	yield(owner, "ready")
	var max_jump_height = 4.2 * Globals.UNIT_SIZE
	floor_snap = FLOOR_SNAP
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	max_run_jump_velocity = -sqrt(2 * gravity * (max_jump_height + Globals.UNIT_SIZE))
	min_jump_velocity = -sqrt(2 * gravity * 1.25 * Globals.UNIT_SIZE)


func physics_process(_delta: float) -> void:
	var direction = get_direction()

	var acc = deceleration_idle
	if direction:
		# If moving in current direction.
		if sign(velocity.x) == direction:
			if speed == SPEED_RUN:
				acc = acceleration_run
				_state_machine.transition_to("Move/Run")
			else:
				acc = acceleration_walk
				_state_machine.transition_to("Move/Walk")
		elif velocity.x:
			acc = deceleration_skid
	else:
		_state_machine.transition_to("Move/Idle")

	velocity.x = lerp(velocity.x, direction * speed, acc)

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


func get_direction() -> float:
	return Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

