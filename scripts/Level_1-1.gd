extends Node2D

var checkpoint_reached = false

onready var player = $Player
onready var checkpoint = $Checkpoint


func _ready() -> void:
#	Engine.time_scale = .2
	Globals.GameMusic.play(Globals.music["main"])
	if Globals.GameState.checkpoint_reached:
		player.position  = checkpoint.global_position

