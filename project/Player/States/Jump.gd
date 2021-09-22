extends PlayerState


func physics_process(delta: float) -> void:
	# sideways logic for jumping.... maybe get initial direction and if pressing
	# other way, only move slightly back

	_parent.apply_velocity(delta)

	if (_parent.velocity.y  >= 0):
		_state_machine.transition_to("Move/Fall")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("jump") and _parent.velocity.y < _parent.min_jump_velocity:
		_parent.velocity.y = _parent.min_jump_velocity
	if event.is_action_released("run"):
		_parent.speed = _parent.SPEED_WALK


func enter(_msg: Dictionary = {}) -> void:
	_parent.snap = Vector2.ZERO
	_parent.velocity.y = _parent.max_jump_velocity


func exit() -> void:
	# fix
	_parent.snap = Vector2.DOWN * 8
