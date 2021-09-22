extends PlayerState


func physics_process(delta: float) -> void:
	# sideways logic for jumping.... maybe get initial direction and if pressing
	# other way, only move slightly back

	_parent.apply_velocity(delta)

	if (_parent.velocity.y == 0):
		_state_machine.transition_to("Move/Idle")


func unhandled_input(event: InputEvent) -> void:
	#probably remove, handle run speed manually..?
	_parent.unhandled_input(event)
#	if event.is_action_released("run"):
#		_parent.speed = _parent.SPEED_WALK
