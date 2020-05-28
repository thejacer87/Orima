extends Node2D

onready var animation_player = $Fireballs/AnimationPlayer

func _ready():
	$ItemBlock.is_empty = true
	animation_player.play("spin")


func _on_Fireballs_body_entered(player : Player) -> void:
	player.damage()
