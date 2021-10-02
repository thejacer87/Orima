extends Block


func _ready() -> void:
	pass


func _on_HitDetector_body_entered(body: Node) -> void:
	.hit()
