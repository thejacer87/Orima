extends PlayerState


func physics_process(delta: float) -> void:
	pass


func unhandled_input(event: InputEvent) -> void:
	pass


func enter(_msg: Dictionary = {}) -> void:
	disable_collisions()


func enable_collision(collision: CollisionPolygon2D) -> void:
	collision.set_deferred("disabled", false)


func disable_collisions() -> void:
	for shape in get_tree().get_nodes_in_group("collisions"):
		shape.set_deferred("disabled", true)
