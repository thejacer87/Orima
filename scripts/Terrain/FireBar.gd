extends Node2D

onready var animation_player = $Fireballs/AnimationPlayer
onready var item_block = $ItemBlock

func _ready():
	item_block.is_empty = true
	item_block.modulate = "#CE4D08"
	animation_player.play("spin")


func _on_Fireballs_body_entered(player : Player) -> void:
	player.damage()
