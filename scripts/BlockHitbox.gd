extends Area2D

signal bump(body)

func _ready() -> void:
	pass


func _on_BlockHitbox_body_entered(body: Node) -> void:
	emit_signal("bump", body)
