extends KinematicBody2D
class_name Enemy


#var speed := 1.0 * Globals.UNIT_SIZE
var speed := 16.0
var velocity := Vector2.ZERO
var direction := -1
var gravity := 98


func _physics_process(delta: float) -> void:
	velocity.x = speed * direction

	velocity.y += gravity * gravity * delta

	velocity = move_and_slide(velocity, Globals.FLOOR)

	if is_on_wall():
		direction *= -1


func die():
	queue_free()


func _on_HitCollision_orima_entered(orima: Orima) -> void:
	if orima.velocity.y > 0:
		$HurtCollision.set_deferred("monitoring", false)
		orima.enemy_bounce()
		die()


func _on_HurtCollision_orima_entered(orima: Orima) -> void:
	$HitCollision.set_deferred("monitoring", false)
	orima.die()
