extends KinematicBody2D

const FLOOR = Vector2.UP

var speed := 1.75 * Globals.UNIT_SIZE
var velocity := Vector2()
var direction := 1
var gravity := 531.2

func _physics_process(delta: float) -> void:
	velocity.x = speed * direction
	# just need something so it stays on the ground
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, FLOOR)

	if is_on_wall():
		direction *= -1


func _on_body_entered(body: Node) -> void:
	queue_free()


func _on_Enemy_body_entered(body: Node) -> void:
	direction *= -1


func _on_Area2D2_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.damage()

