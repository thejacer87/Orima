extends Node2D

var checkpoint_reached = false

onready var player = $Player
onready var checkpoint = $Checkpoint
onready var dynamic_tilemap = $DynamicTileMap


func _ready() -> void:
	Globals.convert_tilecells_to_nodes(self, dynamic_tilemap, "#008787")
	Globals.GameState.update_GUI()
	Globals.GameMusic.play(Globals.music["underworld"])
	if Globals.GameState.checkpoint_reached:
		player.position  = checkpoint.global_position
		player.position.y = 192
