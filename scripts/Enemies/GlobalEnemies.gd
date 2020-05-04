extends Node

const PIRANHA = preload("res://scenes/Enemies/PiranhaPlant.tscn")
const GOOMBA = preload("res://scenes/Enemies/Goomba.tscn")
const KOOPA_GREEN = preload("res://scenes/Enemies/KoopaGreen.tscn")
#const KOOPA_RED = preload("res://scenes/Enemies/KoopaRed.tscn")


func _ready() -> void:
	print("enemies ready")
	print(PIRANHA)
	Globals.Enemies = self

