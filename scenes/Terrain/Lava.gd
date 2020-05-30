extends Area2D


func _ready() -> void:
	pass


func _on_Lava_body_entered(player: Player) -> void:
	player.die()
