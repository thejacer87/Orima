extends KinematicBody2D
class_name Enemy

const FLOOR = Vector2.UP

var speed := 1.75 * Globals.UNIT_SIZE
var velocity := Vector2.ZERO
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


func squish():
	velocity = Vector2.ZERO
	speed = 0
	gravity = 0
	$AnimationPlayer.play("dead")
	$Squish.play()
	yield(get_tree().create_timer(1), "timeout")
	die()


func flip():
	velocity.y -= 200
	$AnimationPlayer.play("flip")
	$Terrain.set_deferred("disabled", true)
	$PlayerDamage/CollisionShape2D.set_deferred("disabled", true)
	$Turnaround/CollisionShape2D.set_deferred("disabled", true)
	$Kill/CollisionShape2D.set_deferred("disabled", true)
	yield(get_tree().create_timer(3), "timeout")
	die()

func _on_body_entered(player: Player) -> void:
	player.velocity.y += -350
	squish()


func _on_Enemy_body_entered(body: Node) -> void:
	direction *= -1

func _on_PlayerDamage_body_entered(body: Node) -> void:
	if "Player" in body.name:
		body.damage()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	is_on_screen = true
