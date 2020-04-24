extends Node2D


func _ready() -> void:
	var audio = Globals.GameMusic.get_node("Audio")
	audio.stream.resource_path(Globals.music["underground"])
