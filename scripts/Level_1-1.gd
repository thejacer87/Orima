extends Node2D


func _ready() -> void:
	Globals.GameMusic.get_node("Aduio").play()
