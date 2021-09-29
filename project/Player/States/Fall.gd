extends PlayerState

var initial_direction := 0

func physics_process(_delta: float) -> void:
	var direction = _parent.get_direction()

	if direction:
		if direction != initial_direction:
			_parent.velocity.x = lerp(_parent.velocity.x, direction * _parent.SPEED_WALK, _parent.friction * 2)
		else:
			_parent.velocity.x = lerp(_parent.velocity.x, direction * _parent.speed, _parent.friction)

	_parent.apply_velocity()

	if (_parent.velocity.y <= 0):
		_state_machine.transition_to("Move/Idle")


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("run"):
		_parent.speed = _parent.SPEED_WALK


func enter(_msg: Dictionary = {}) -> void:
	initial_direction = _parent.get_direction()
