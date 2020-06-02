extends Node2D

onready var animation_player := $AnimationPlayer
onready var mouth := $Mouth
onready var fireball := preload("res://scenes/Enemies/Fireball.tscn")

func _ready() -> void:
	pass


func _on_Body_body_entered(player: Player) -> void:
	player.damage()


func _on_Timer_timeout() -> void:
	animation_player.play("jump")
	var fb_instance = fireball.instance()
	fb_instance.global_position = mouth.global_position
	get_tree().get_root().add_child(fb_instance)
	
