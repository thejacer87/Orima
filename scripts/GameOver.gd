extends Control


func _ready() -> void:
	yield(get_tree().create_timer(6.0), "timeout")
	SceneTransition.change_scene(Globals.levels["1-1"], Globals.default_starting_position)
