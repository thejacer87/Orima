extends Node2D


func _ready() -> void:
	pass


func _on_Area2D_body_entered(_body: Node) -> void:
	$Area2D.set_deferred("monitoring", false)
	set_deferred("visible", false)
	$AudioStreamPlayer.play()
	yield($AudioStreamPlayer, "finished")
	queue_free()


func activate() -> void:
	# up coin counter
	$AnimationPlayer.play("activate")

