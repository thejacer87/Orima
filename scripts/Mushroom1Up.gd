extends Mushroom

func _on_Powerup_body_entered(player: Player) -> void:
	player.one_up()
	visible = false
	$Audio_Collect.play()
	# need to give it time to play the audio before freeing
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
