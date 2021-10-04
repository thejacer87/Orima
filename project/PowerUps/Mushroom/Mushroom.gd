extends Area2D


func _ready() -> void:
	global_position += Vector2(0, -16)


func _on_Mushroom_body_entered(orima: Orima) -> void:
	orima.collect_powerup("Mushroom")
	queue_free()


func activate() -> void:
	$AnimationPlayer.play("activate")
