extends Control

onready var start_button := $Start
onready var quit_button := $Quit

func _ready() -> void:
	start_button.grab_focus()


func _on_Start_pressed() -> void:
	SceneTransition.change_scene(Globals.levels["1-1"], Globals.default_starting_position)


func _on_Quit_pressed() -> void:
	get_tree().quit()
