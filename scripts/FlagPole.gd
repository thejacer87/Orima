extends Area2D
class_name FlagPole

export(String, FILE, "*tscn") var target_scene
export(Vector2) var local_position

onready var slide_animation := $AnimationPlayer
onready var slide_audio := $Slide
onready var clear_audio := $StageClear

func _on_FlagPole_body_entered(player: Player) -> void:
	Globals.GameState.checkpoint_reached = false
	Globals.GameMusic.get_node("Audio").stop()
	slide_audio.play()
	player.slide()
	slide_animation.play("drop")
	yield(get_tree().create_timer(1.5), "timeout")
	clear_audio.play()
	yield(get_tree().create_timer(5.25), "timeout")
	SceneTransition.change_scene(target_scene, local_position)
