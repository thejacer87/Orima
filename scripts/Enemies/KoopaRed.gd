extends KoopaGreen

onready var ledge_turnaround = $LedgeTurnaround

func _physics_process(delta: float) -> void:
	if is_flipped and not is_sliding:
		kick()

	if is_sliding and is_on_wall():
		audio_bump.play()

	if not ledge_turnaround.is_colliding():
		direction *= -1


func enable_collisions():
	.enable_collisions()
	ledge_turnaround.set_deferred("enabled", true)


func remove_collisions():
	.remove_collisions()
	ledge_turnaround.set_deferred("enabled", false)
