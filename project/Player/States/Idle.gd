extends PlayerState


func physics_process(delta: float) -> void:
	# The lerp takes to long to actually get the velocity to zero.
	# So clamp it when it gets to 0.5.
	if abs(_parent.velocity.x) <= 0.5:
		_parent.velocity.x = 0
	_parent.physics_process(delta)


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)

