extends Node2D
class_name WorldBase


export(Dictionary) var camera_limit = {
	left = -10000000,
	top = -10000000,
	right = 10000000,
	bottom = 10000000
}


func _ready() -> void:
	Globals.Player.set_current_camera(camera_limit)
