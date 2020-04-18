extends Area2D


func _ready() -> void:
	pass


func _on_DeathBlock_body_entered(body: Node) -> void:
	body.die()
