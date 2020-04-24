extends Node

const UNIT_SIZE = 16

var GameState
var Player
var GUI

var destination := Vector2()
var loader
var wait_frames
var time_max = 100 # msec
var current_scene

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
	var player = current_scene.get_node("Player").get_node("Player")
	player.global_position = destination   # move player to new position
