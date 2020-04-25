extends Node2D

onready var audiostream := $Audio

func _ready() -> void:
	Globals.GameMusic = self

func play(path) -> void:
	var audio_file = load(path)
	audiostream.stop()
	audiostream.stream = audio_file
	audiostream.play()

func stop() -> void:
	audiostream.stop()
