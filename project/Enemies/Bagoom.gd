extends Enemy


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity.y = min(velocity.y + gravity * delta, 0)
	velocity = move_and_slide_with_snap(velocity, Vector2.ZERO, Globals.FLOOR)

