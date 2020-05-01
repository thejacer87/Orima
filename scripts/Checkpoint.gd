extends Area2D


func _on_Checkpoint_body_entered(body: Node) -> void:
	Globals.GameState.checkpoint_reached = true
