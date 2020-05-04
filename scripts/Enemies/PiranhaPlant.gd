extends KinematicBody2D

onready var animation_player = $AnimationPlayer




func _on_Timer_timeout():
	print("timeout")
	animation_player.play("exit_pipe")
