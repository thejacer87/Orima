extends Control


func _ready() -> void:
	Globals.GameState.checkpoint_reached = false
	yield(get_tree().create_timer(6.0), "timeout")
	get_tree().change_scene(Globals.scenes["menu"])
	queue_free()
