extends Node2D

const LEFT_LIMIT := -72
const RIGHT_LIMIT := 32

onready var animation_player := $AnimationPlayer
onready var mouth := $Body/Mouth
onready var fireball := preload("res://scenes/Enemies/Fireball.tscn")

var original_position

func _ready() -> void:
	original_position = position


func _on_Body_body_entered(player: Player) -> void:
	player.damage()


func _on_Timer_timeout() -> void:
	animation_player.play("jump")
	move_toward_orima()


func _on_FireTimer_random_timeout() -> void:
	var fb_instance = fireball.instance()
	fb_instance.global_position = mouth.global_position
	get_tree().get_root().add_child(fb_instance)


func move_toward_orima() -> void:
	var dest = lerp(position, original_position + Vector2(LEFT_LIMIT, 0), .5)
	position = dest
