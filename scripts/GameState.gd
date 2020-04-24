extends Node

export(int) onready var starting_lives := 3 setget set_lives
var lives

func _ready() -> void:
	Globals.GameState = self
	lives = starting_lives


func die() -> void:
	print(lives)
	lives -= 1
	if lives < 0:
		game_over()
	else:
		SceneTransition.change_scene(Globals.levels["1-1"], Globals.default_starting_position)
		


func game_over() -> void:
	get_tree().change_scene("res://scenes/GameOver.tscn")


func set_lives(value) -> void:
	self.lives = value
