extends Block


func _ready() -> void:
	pass


func hit(collision: KinematicCollision2D) -> void:
	if collision.normal == Vector2.DOWN:
		var name = Globals.Player.powerup_state_machine._state_name
		if Globals.Player.powerup_state_machine._state_name == "Normal":
			$AnimationPlayer.play("bump")
		else:
			$AnimationPlayer.play("break")
