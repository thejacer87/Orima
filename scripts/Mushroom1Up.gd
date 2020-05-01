extends Mushroom

func _on_Powerup_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.one_up()
		queue_free()
