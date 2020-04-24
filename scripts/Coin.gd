extends Area2D

onready var animation = $AnimationPlayer
onready var audio = $Collect

func _ready() -> void:
	pass


func _on_Coin_body_entered(body: Node) -> void:
	animation.play("collect")
	audio.play()
	yield(get_tree().create_timer(0.75), "timeout")
	queue_free()


func activate() -> void:
	animation.play("collect")
	audio.play()
	yield(get_tree().create_timer(0.75), "timeout")
	queue_free()
