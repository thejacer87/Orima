extends Control

onready var pause = $Pause
onready var audio = $PauseAudio
onready var resume_button = $PauseMenu/Resume

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause()


func pause() -> void:
	audio.play()
	resume_button.grab_focus()
	get_tree().paused = not get_tree().paused
	visible = not visible


func _on_Resume_pressed() -> void:
	pause()


func _on_Quit_pressed() -> void:
	Globals.GameMusic.stop()
	get_tree().quit()

