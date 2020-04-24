extends Mushroom


func _on_Powerup_body_entered(player: Player) -> void:
	player.one_up()
	queue_free()
