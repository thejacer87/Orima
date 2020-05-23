extends Node


enum powerup_states {SMALL, BIG, FIRE_FLOWER, INVICIBLE}

onready var starting_lives := 3
var lives setget set_lives
var coins setget set_coins
var powerup setget set_powerup
var checkpoint_reached = false


func _ready() -> void:
	Globals.GameState = self
	self.lives = max(0, starting_lives)
	self.coins = 0
	self.powerup = powerup_states.SMALL


func die() -> void:
	Globals.GameMusic.play(Globals.music["die"])
	self.powerup = powerup_states.SMALL
	lives -= 1
	if lives < 0:
		game_over()
	else:
		yield(get_tree().create_timer(2), "timeout")
		SceneTransition.reload_scene(
			Globals.current_scene.filename,
			Globals.default_starting_position
		)


func update_GUI() -> void:
	Globals.GUI.update_GUI(coins, lives)


func game_over() -> void:
	yield(get_tree().create_timer(3), "timeout")
	Globals.goto_level(Globals.scenes["gameover"], Vector2.ZERO)


func set_lives(value) -> void:
	lives = value
	update_GUI()


func set_coins(value) -> void:
	coins = value
	update_GUI()


func set_powerup(value) -> void:
	powerup = value
