extends Area2D
class_name FlagPole

export(String, FILE, "*tscn") var target_scene
export(Vector2) var local_position

func _on_FlagPole_body_entered(body: Node) -> void:
	Globals.goto_scene(target_scene, local_position)
