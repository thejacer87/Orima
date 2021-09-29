extends PlayerState


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("run"):
		_state_machine.transition_to("Move/Walk")
	_parent.unhandled_input(event)


func enter(_msg: Dictionary = {}) -> void:
	owner.set_run_shape(true)


func exit() -> void:
	owner.set_run_shape(false)
