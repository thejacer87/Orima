extends Node

const UNIT_SIZE = 16
const COIN = preload("res://scenes/Coin.tscn")
const BRICK = preload("res://scenes/Brick.tscn")
const BLOCK = preload("res://scenes/ItemBlock.tscn")
const FIREBAR = preload("res://scenes/Terrain/FireBar.tscn")
const MUSHROOM = preload("res://scenes/Mushroom.tscn")
const MUSHROOM_1UP = preload("res://scenes/Mushroom1Up.tscn")

var GameState
var GUI
var GameMusic
var Player
var Enemies

var default_starting_position := Vector2(40.0, 104.0)
var levels = {
		"1-1": "res://scenes/Levels/1-1.tscn",
		"1-2": "res://scenes/Levels/1-2.tscn",
		"1-3": "res://scenes/Levels/1-3.tscn",
		"1-4": "res://scenes/Levels/1-4.tscn",
	}
# gross, but helpful
var levels_flip = {
		"res://scenes/Levels/1-1.tscn": "1-1",
		"res://scenes/Levels/1-2.tscn": "1-2",
		"res://scenes/Levels/1-3.tscn": "1-3",
		"res://scenes/Levels/1-4.tscn": "1-4",
	}
var scenes = {
		"menu": "res://scenes/MainMenu.tscn",
		"gameover": "res://scenes/GameOver.tscn",
		"winner": "res://scenes/Winner.tscn",
	}
var music = {
		"menu": "res://SFX/Music/title.wav",
		"main": "res://SFX/Music/01-main-theme-overworld.wav",
		"die": "res://SFX/Sounds/smb_mariodie.wav",
		"underworld": "res://SFX/Music/02-underworld.wav",
		"castle": "res://SFX/Music/04-castle.wav",
	}
var sounds = {
		"1up": "res://SFX/Sounds/smb_1-up.wav",
	}
var sprites = {
		"brick": "res://sprites/brick.png",
		"koopa_red": "res://sprites/koopa_red.png"
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


func goto_level(level_path, coordinates = null):
	destination = coordinates
	loader = ResourceLoader.load_interactive(level_path)
	if loader == null:
		#show_error()
		return
	set_process(true)

	if is_instance_valid(current_scene):
		current_scene.queue_free()

	# start your "loading..." animation
	#get_node("animation").play("loading")

	wait_frames = 1

func convert_tilecells_to_nodes(level, tilemap, color := "#CE4D08") -> void:
	var cells = tilemap.get_used_cells()
	for cell in cells:
		var cell_id = tilemap.get_cellv(cell)
		if cell_id != tilemap.INVALID_CELL:
			var tile_name = tilemap.tile_set.tile_get_name(cell_id)
			var child
			var offset = Vector2.ZERO
			match tile_name:
				"brick.png 0":
					child = Globals.BRICK.instance()
					child.get_node("Sprite").self_modulate = color
				"block.png 1":
					child = Globals.BLOCK.instance()
					child.get_node("Sprite").self_modulate = color
					child.get_node("EmptySprite").self_modulate = color
					child.get_node("Items").add_child(Globals.COIN.instance())
				"block_empty.png 10":
					child = Globals.BLOCK.instance()
					child.get_node("Sprite").self_modulate = color
					child.get_node("EmptySprite").self_modulate = color
					child.get_node("Sprite").visible = false
					child.is_empty = true
				"mushroom.png 2":
					child = Globals.BLOCK.instance()
					child.get_node("Sprite").self_modulate = color
					child.get_node("EmptySprite").self_modulate = color
					child.get_node("Items").add_child(Globals.MUSHROOM.instance())
				"brick_mushroom.png 13":
					child = Globals.BLOCK.instance()
					child.get_node("Sprite").self_modulate = color
					child.get_node("EmptySprite").self_modulate = color
					child.get_node("Sprite").set_texture(load(Globals.sprites.brick))
					child.get_node("Items").add_child(Globals.MUSHROOM.instance())
				"brick_mushroom_1up.png 12":
					child = Globals.BLOCK.instance()
					child.get_node("Sprite").self_modulate = color
					child.get_node("EmptySprite").self_modulate = color
					child.get_node("Sprite").set_texture(load(Globals.sprites.brick))
					child.get_node("Items").add_child(Globals.MUSHROOM_1UP.instance())
				"bush.png 15":
					child = Globals.BLOCK.instance()
					child.get_node("Sprite").self_modulate = color
					child.get_node("EmptySprite").self_modulate = color
					child.is_hidden = true
					child.get_node("Items").add_child(Globals.MUSHROOM_1UP.instance())
				"cloud.png 9":
					child = Globals.BLOCK.instance()
					child.get_node("EmptySprite").self_modulate = "CCCCCC"
					child.is_hidden = true
					var coin = Globals.COIN.instance()
					coin.monitoring = false
					coin.monitorable = false
					child.get_node("Items").add_child(coin)
				"coin.png 3":
					child = Globals.COIN.instance()
				"piranha_open.png 4":
					child = Globals.Enemies.PIRANHA.instance()
					offset = Vector2(8, 0)
				"goomba.png 5":
					child = Globals.Enemies.GOOMBA.instance()
				"koopa_green.png 6":
					child = Globals.Enemies.KOOPA.instance()
				"koopa_red.png 7":
					child = Globals.Enemies.KOOPA.instance()
					child.is_red = true
				"koopa_flying.png 14":
					child = Globals.Enemies.PARATROOPA.instance()
				"fireball.png 16":
					child = Globals.FIREBAR.instance()
				"brick_coin.png 11":
					child = Globals.BLOCK.instance()
					child.get_node("Sprite").set_texture(load(Globals.sprites.brick))
					child.get_node("Sprite").self_modulate = color
					child.get_node("EmptySprite").self_modulate = color
					for n in range(5):
						child.get_node("Items").add_child(Globals.COIN.instance())

			if child != null:
				child.position = tilemap.map_to_world(cell) + (tilemap.cell_size / 2) + offset
				level.add_child(child)
	tilemap.clear()

func set_new_scene(scene_resource):
	set_process(false)
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	var player = current_scene.get_node("Player")
	if player != null and destination != null and not GameState.checkpoint_reached:
		player.global_position = destination  # move player to new position
