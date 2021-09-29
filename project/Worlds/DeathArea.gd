extends Area2D


func _ready() -> void:
	pass


func _on_DeathArea_body_entered(body: Node2D) -> void:
	print(body.name)
	print("died")
	body.die()
