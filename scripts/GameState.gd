extends Node


enum powerup_states {SMALL, BIG, INVICIBLE}

onready var starting_lives := 3
var lives setget set_lives
var powerup setget set_powerup


func _ready() -> void:
	Globals.GameState = self
	self.lives = max(0, starting_lives)
	self.powerup = powerup_states.SMALL


func die() -> void:
	Globals.GameMusic.play(Globals.music["die"])
	lives -= 1
	if lives < 0:
		game_over()
	else:
		yield(get_tree().create_timer(2), "timeout")
		SceneTransition.reload_scene(
			Globals.current_scene.filename,
			Globals.default_starting_position
		)


func game_over() -> void:
	yield(get_tree().create_timer(3), "timeout")
	Globals.goto_level(Globals.scenes["gameover"], Vector2.ZERO)


func set_lives(value) -> void:
	lives = value


func set_powerup(value) -> void:
	powerup = value
