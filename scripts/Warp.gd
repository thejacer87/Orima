extends Area2D

export(String, FILE, "*tscn") var target_scene
export(Vector2) var direction


func _process(delta: float) -> void:
	# Only the player can overlap
	var bodies = get_overlapping_bodies()
	var warp_direction = "down"
	match direction:
		Vector2.UP:
			warp_direction = "up"
		Vector2.RIGHT:
			warp_direction = "right"

	if (Input.is_action_pressed(warp_direction) and bodies.size() > 0):
		print("warp")
		print(bodies[0].name)
		bodies[0].warp(direction)
		# wait for warp animation to finish
		yield(get_tree().create_timer(0.95), "timeout")
		get_tree().change_scene(target_scene)
