extends Area2D


func _on_Fireball_body_entered(player: Player) -> void:
	player.damage()
