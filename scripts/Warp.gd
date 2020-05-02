extends Area2D

export(String, FILE, "*tscn") var target_scene
export(Vector2) var direction
export(Vector2) var exit_direction
export(Vector2) var local_position

onready var pipe_audio := $EnterPipe

func _process(delta: float) -> void:
	# Only the player can overlap
	var bodies = get_overlapping_bodies()
	var warp_direction = "down"
	match direction:
		Vector2.UP:
			warp_direction = "up"
		Vector2.RIGHT:
			warp_direction = "right"
		Vector2.LEFT:
			warp_direction = "left"

	if (Input.is_action_pressed(warp_direction) and bodies.size() > 0):
		var player: Player = bodies[0]
		pipe_audio.play()
		player.warp(direction)
		player.is_warping = true
		# wait for warp animation to finish
		yield(get_tree().create_timer(1), "timeout")
		player.is_warping = false
		Globals.goto_level(target_scene, local_position)
		yield(get_tree().create_timer(0.5), "timeout")
