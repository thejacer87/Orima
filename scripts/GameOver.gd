extends Control


func _ready() -> void:
	yield(get_tree().create_timer(6.0), "timeout")
	get_tree().change_scene("res://scenes/Level_1-1.tscn")
