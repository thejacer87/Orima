extends StateMachine


func _ready() -> void:
	add_state("idle")
	add_state("warping")
	add_state("dying")
	add_state("sliding")
	call_deferred("set_state", states.idle)


func _state_logic(delta) -> void:
	if not parent.is_dying and not parent.is_warping:
		parent.run()
		parent.jump()
		parent.move(delta)


func _get_transition(_delta) -> String:
	match state:
		states.warping:
			return ""

	return ""


func _enter_state(new_state, old_state) -> void:
	pass

func _exit_state(old_state, new_state) -> void:
	pass
