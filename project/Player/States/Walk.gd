extends PlayerState


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("run"):
		_state_machine.transition_to("Move/Run")
	_parent.unhandled_input(event)

