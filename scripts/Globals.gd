extends Node

const UNIT_SIZE = 16

var GameState
var GameMusic
var Player
var GUI

var default_starting_position := Vector2(40.0, 216.0)
var levels = {
		"1-1": "res://scenes/Level_1-1.tscn",
		"1-2": "res://scenes/Level_1-2.tscn",
		"1-3": "res://scenes/Level_1-3.tscn",
		"1-4": "res://scenes/Level_1-4.tscn",
	}
# gross, but helpful
var levels_flip = {
		"res://scenes/Level_1-1.tscn": "1-1",
		"res://scenes/Level_1-2.tscn": "1-2",
		"res://scenes/Level_1-3.tscn": "1-3",
		"res://scenes/Level_1-4.tscn": "1-4",
	}
var scenes = {
		"menu": "res://scenes/MainMenu.tscn",
		"gameover": "res://scenes/GameOver.tscn",
	}
var music = {
		"menu": "res://SFX/Music/title.wav",
		"main": "res://SFX/Music/01-main-theme-overworld.wav",
		"die": "res://SFX/Sounds/smb_mariodie.wav",
		"underworld": "res://SFX/Music/02-underworld.wav",
	}
var destination := Vector2()
var loader
var wait_frames
var time_max = 100 # msec
var current_scene
var current_level

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)


func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread

		# poll your loader
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			pass
			#update_progress()
		else: # error during loading
			#show_error()
			loader = null
			break


func goto_level(level_path, coordinates):
	destination = coordinates
	loader = ResourceLoader.load_interactive(level_path)
	if loader == null:
		#show_error()
		return
	set_process(true)

	current_scene.queue_free() # get rid of the old scene

	# start your "loading..." animation
	#get_node("animation").play("loading")

	wait_frames = 1


func set_new_scene(scene_resource):
	set_process(false)
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	var player = current_scene.get_node("Player")
	if player != null and not GameState.checkpoint_reached:
		player.global_position = destination   # move player to new position
