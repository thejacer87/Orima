extends CanvasLayer

signal scene_changed()

onready var animation_player := $AnimationPlayer
onready var black := $Control/Black

func change_scene(scene, position, delay = 1.5):
	animation_player.play("fade")
	yield(get_tree().create_timer(delay), "timeout")
	Globals.goto_level(scene, position)
	animation_player.play_backwards("fade")
	yield(get_tree().create_timer(delay), "timeout")
	emit_signal("scene_changed")
