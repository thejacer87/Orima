extends PlayerState

var initial_direction := 0

func physics_process(_delta: float) -> void:
	var direction = _parent.get_direction()

	if not initial_direction and not direction:
		# maybe disable the collision and move orima manually?
		_parent.velocity.x = 0

	if direction:
		if direction != initial_direction:
			_parent.velocity.x = lerp(_parent.velocity.x, direction * _parent.SPEED_WALK, _parent.friction * 2)
		else:
			_parent.velocity.x = lerp(_parent.velocity.x, direction * _parent.speed, _parent.friction)

	_parent.apply_velocity()

	if (_parent.velocity.y >= 0):
		_state_machine.transition_to("Move/Fall")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("jump") and _parent.velocity.y < _parent.min_jump_velocity:
		_parent.velocity.y = _parent.min_jump_velocity
	if event.is_action_released("run"):
		_parent.speed = _parent.SPEED_WALK


func enter(_msg: Dictionary = {}) -> void:
	initial_direction = _parent.get_direction()
	# Change snap to enable jump.
	_parent.floor_snap = Vector2.ZERO
	# Increase the initial jump velocity if the player is running.
	var running_jump = abs(_parent.velocity.x) > _parent.SPEED_WALK
	_parent.velocity.y = _parent.max_run_jump_velocity if running_jump else _parent.max_jump_velocity


func exit() -> void:
	_parent.floor_snap = _parent.FLOOR_SNAP
