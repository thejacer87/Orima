extends Node2D


func _ready() -> void:
#	Engine.time_scale = .2
	Globals.GameMusic.play(Globals.music["main"])
