extends Node2D

var checkpoint_reached = false

onready var player = $Player
onready var dynamic_tilemap = $DynamicTileMap

func _ready() -> void:
	Globals.convert_tilecells_to_nodes(self, dynamic_tilemap)
	Globals.GameState.update_GUI()
	Globals.GameMusic.play(Globals.music["castle"])
