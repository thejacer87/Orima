extends KoopaGreen

onready var ledge_turnaround = $LedgeTurnaround
onready var ledge_turnaround2 = $LedgeTurnaround2

func _physics_process(delta: float) -> void:
	if is_flipped and not is_sliding:
		kick()

	if is_sliding and is_on_wall():
		audio_bump.play()

	if not ledge_turnaround.is_colliding() or not ledge_turnaround2.is_colliding():
		direction *= -1


func enable_collisions():
	.enable_collisions()
	ledge_turnaround.set_deferred("enabled", true)
	ledge_turnaround2.set_deferred("enabled", true)


func remove_collisions():
	.remove_collisions()
	ledge_turnaround.set_deferred("enabled", false)
	ledge_turnaround2.set_deferred("enabled", false)
