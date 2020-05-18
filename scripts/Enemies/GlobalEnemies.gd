extends Node

const PIRANHA = preload("res://scenes/Enemies/PiranhaPlant.tscn")
const GOOMBA = preload("res://scenes/Enemies/Goomba.tscn")
const KOOPA = preload("res://scenes/Enemies/Koopa.tscn")


func _ready() -> void:
	Globals.Enemies = self

