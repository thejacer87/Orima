extends Node

export(int) onready var starting_lives := 3 setget set_lives
var lives

func _ready() -> void:
	Globals.GameState = self
	lives = starting_lives


func die() -> void:
	lives -= 1
	if lives < 0:
		game_over()


func game_over() -> void:
	get_tree().change_scene("res://scenes/GameOver.tscn")


func set_lives(value) -> void:
	self.lives = value
