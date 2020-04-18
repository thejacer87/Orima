extends KinematicBody2D

const FLOOR = Vector2.UP

var speed := 1.75 * Globals.UNIT_SIZE
var velocity := Vector2()
var direction := 1
var gravity := 531.2
var is_on_screen := false


func _physics_process(delta: float) -> void:
	if is_on_screen:
		velocity.x = speed * direction
		# just need something so it stays on the ground
		velocity.y += gravity * delta

		velocity = move_and_slide(velocity, FLOOR)

		if is_on_wall():
			direction *= -1


func die():
	queue_free()


func _on_body_entered(body: Node) -> void:
	die()


func _on_Enemy_body_entered(body: Node) -> void:
	direction *= -1


func _on_Area2D2_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.damage()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	is_on_screen = true
