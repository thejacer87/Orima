extends CanvasLayer

signal scene_changed()

onready var animation_player := $AnimationPlayer
onready var black := $Control/Black
onready var lives := $Control/Info/Lives
onready var level := $Control/Info/World

func change_scene(scene, position, delay = 1.5):
	lives.text = "x   %d" % Globals.GameState.lives
	level.text = "WORLD %s" % Globals.levels_flip[scene]
	animation_player.play("fade_out")
	yield(get_tree().create_timer(delay), "timeout")
	Globals.goto_level(scene, position)
	animation_player.play("fade_in")
	yield(get_tree().create_timer(delay), "timeout")
	emit_signal("scene_changed")

func reload_scene(scene, position = null, delay = 1.5):
	lives.text = "x   %d" % Globals.GameState.lives
	level.text = "WORLD %s" % Globals.levels_flip[scene]
	animation_player.play("fade_out")
	yield(get_tree().create_timer(delay), "timeout")
	Globals.goto_level(scene, position)
	animation_player.play("fade_in")
	yield(get_tree().create_timer(delay), "timeout")
	emit_signal("scene_changed")
