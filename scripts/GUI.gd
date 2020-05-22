extends Node

onready var life_count = $TextureRect/VBoxContainer/HBoxContainer/LivesCounter/Lives
onready var coin_count = $TextureRect/VBoxContainer/HBoxContainer/CoinsCounter/Coins

func _ready() -> void:
	Globals.GUI = self


func update_GUI(coins, lives) -> void:
	if life_count != null:
		life_count.text = "x %d" % lives
	if coin_count != null:
		coin_count.text = "x %d" % coins
