extends Area2D


func _ready() -> void:
	pass


func _on_FireFlower_body_entered(orima: Orima) -> void:
	orima.collect_powerup("FireFlower")
	queue_free()
