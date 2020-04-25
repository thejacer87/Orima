extends Control

onready var start_button := $Start
onready var quit_button := $Quit
onready var audio := $Title

# Konami code
var sequence = [
	KEY_UP,
	KEY_UP,
	KEY_DOWN,
	KEY_DOWN,
	KEY_LEFT,
	KEY_RIGHT,
	KEY_LEFT,
	KEY_RIGHT,
	KEY_B,
	KEY_A
]
var sequence_index = 0

func _ready() -> void:
	Globals.GameMusic.play(Globals.music["menu"])
	start_button.grab_focus()


func _process(delta: float) -> void:
	pass

func cheat_code(event):
	if event.type == InputEvent.KEY and event.pressed:
		if event.scancode == sequence[sequence_index]:
			sequence_index += 1
			if sequence_index == sequence.size():
				# Cheat is now active here. Do whatever.
				sequence_index = 0
		else:
			sequence_index = 0

func _on_Start_pressed() -> void:
	SceneTransition.change_scene(Globals.levels["1-1"], Globals.default_starting_position)


func _on_Quit_pressed() -> void:
	Globals.GameMusic.stop()
	get_tree().quit()
