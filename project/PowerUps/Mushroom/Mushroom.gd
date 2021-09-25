extends Area2D


func _ready() -> void:
	pass


func _on_Mushroom_body_entered(orima: Orima) -> void:
	orima.collect_powerup("Mushroom")
	queue_free()

