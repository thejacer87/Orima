extends Node2D

onready var dynamic_tilemap = $DynamicTileMap

func _ready() -> void:
	Globals.convert_tilecells_to_nodes(self, dynamic_tilemap)
	Globals.GameState.update_GUI()
	Globals.GameMusic.play(Globals.music["main"])
