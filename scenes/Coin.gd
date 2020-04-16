extends Area2D

onready var animation = $AnimationPlayer

func _ready() -> void:
	pass


func _on_Coin_body_entered(body: Node) -> void:
	animation.play("collect")
	yield(get_tree().create_timer(0.75), "timeout")
	queue_free()
