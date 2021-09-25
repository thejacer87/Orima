extends PlayerState


func physics_process(delta: float) -> void:
	_parent.physics_process(delta)


func unhandled_input(event: InputEvent) -> void:
	_parent.unhandled_input(event)
	if event.is_action_pressed("fire"):
		print("fireball")


func enter(_msg: Dictionary = {}) -> void:
	owner.play_animation("FireFlower")
