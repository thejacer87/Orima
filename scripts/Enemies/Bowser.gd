extends Node2D

onready var animation_player := $AnimationPlayer


func _ready() -> void:
	pass


func _on_Body_body_entered(player: Player) -> void:
	player.damage()


func _on_Timer_timeout() -> void:
	animation_player.play("jump")
