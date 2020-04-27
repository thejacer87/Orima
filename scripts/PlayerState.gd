extends StateMachine


func _ready() -> void:
	add_state("small")
	add_state("big")
	add_state("warping")
	add_state("dying")
	add_state("sliding")
	call_deferred("set_state", states.small)


func _state_logic(delta) -> void:
	if not parent.is_dying and not parent.is_warping:
		parent.run()
		parent.jump()
		parent.move(delta)


func _get_transition(delta) -> String:
	match state:
		states.small:
			return ""

	return ""


func _enter_state(new_state, old_state) -> void:
	match new_state:
		states.big:
			parent.powerup()


func _exit_state(old_state, new_state) -> void:
	pass
