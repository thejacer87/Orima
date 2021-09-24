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

	_parent.apply_velocity(delta)

	if (_parent.velocity.y == 0):
		_state_machine.transition_to("Move/Idle")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("run"):
		_parent.speed = _parent.SPEED_WALK


func enter(_msg: Dictionary = {}) -> void:
	initial_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
