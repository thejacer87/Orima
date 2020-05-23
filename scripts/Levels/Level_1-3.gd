extends Node2D

var checkpoint_reached = false

onready var player = $Player
onready var checkpoint = $Checkpoint
onready var dynamic_tilemap = $DynamicTileMap


func _ready() -> void:
	Globals.convert_tilecells_to_nodes(self, dynamic_tilemap)
	Globals.GameState.update_GUI()
	Globals.GameMusic.play(Globals.music["main"])
	for enemy in get_tree().get_nodes_in_group('former_paratroopas'):
		enemy.queue_free()
	if Globals.GameState.checkpoint_reached:
		player.position = checkpoint.global_position
		player.position.y = 192


