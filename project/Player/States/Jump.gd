extends PlayerState

var initial_direction := 0

func physics_process(delta: float) -> void:
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if direction:
		if direction != initial_direction:
			_parent.velocity.x = lerp(_parent.velocity.x, direction * _parent.SPEED_WALK, _parent.friction * 2)
		else:
			_parent.velocity.x = lerp(_parent.velocity.x, direction * _parent.speed, _parent.friction)
	elif initial_direction == 0:
		if _parent.velocity.x:
			_parent.velocity.x = lerp(_parent.velocity.x, direction * _parent.SPEED_WALK, 0)
		else:
			_parent.velocity.x = lerp(_parent.velocity.x, direction * _parent.SPEED_WALK, _parent.idle_friction)
#		pass
	_parent.apply_velocity(delta)

	if (_parent.velocity.y >= 0):
		_state_machine.transition_to("Move/Fall")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("jump") and _parent.velocity.y < _parent.min_jump_velocity:
		_parent.velocity.y = _parent.min_jump_velocity
	if event.is_action_released("run"):
		_parent.speed = _parent.SPEED_WALK


func enter(_msg: Dictionary = {}) -> void:
	_parent.snap = Vector2.ZERO
	if abs(_parent.velocity.x) > _parent.SPEED_WALK:
		_parent.velocity.y = _parent.max_run_jump_velocity
	else:
		_parent.velocity.y = _parent.max_jump_velocity
	initial_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")


func exit() -> void:
	# fix
	_parent.snap = Vector2.DOWN * 8
