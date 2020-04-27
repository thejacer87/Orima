extends KinematicBody2D
class_name Mushroom

onready var collision = $CollisionShape2D
onready var activation_animation = $AnimationPlayer
onready var powerup_collision = $Powerup/CollisionShape2D

const FLOOR = Vector2.UP

var active = false
var speed := 1.75 * Globals.UNIT_SIZE
var velocity := Vector2()
var direction := 1
var gravity := 531.2

func _physics_process(delta: float) -> void:
	if active:
		velocity.x = speed * direction
		# just need something so it stays on the ground
		velocity.y += gravity * delta

		velocity = move_and_slide(velocity, FLOOR)

		if is_on_wall():
			direction *= -1


func _on_Powerup_body_entered(player: Player) -> void:
	player.powerup()
	visible = false
	$Audio_Collect.play()
	# need to give it time to play the audio before freeing
	yield(get_tree().create_timer(1), "timeout")
	queue_free()


func activate() -> void:
	active = true
	visible = true
	$Audio_Activate.play()
	activation_animation.play("activate")
	yield(get_tree().create_timer(0.95), "timeout")
	z_index = 0
	powerup_collision.disabled = false
	collision.disabled = false

func bump():
	velocity.y = min(150, velocity.y - 150)
