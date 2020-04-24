extends Node

onready var starting_lives := 3
var lives setget set_lives

func _ready() -> void:
	Globals.GameState = self
	lives = starting_lives


func die() -> void:
	lives -= 1
	if lives < 0:
		game_over()
	else:
		SceneTransition.change_scene(Globals.levels["1-1"], Globals.default_starting_position)


func game_over() -> void:
	SceneTransition.change_scene(Globals.scenes["gameover"], Globals.default_starting_position)


func set_lives(value) -> void:
	lives = value
