extends KinematicBody2D

const FLOOR = Vector2(0, -1)

var speed =  3 * Globals.UNIT_SIZE

var velocity: = Vector2()


func _physics_process(delta: float) -> void:
	velocity.x = -speed

	velocity = move_and_slide(velocity, FLOOR)


func _on_body_entered(body: Node) -> void:
	queue_free()
