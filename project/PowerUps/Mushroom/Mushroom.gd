extends PowerUp
class_name Mushroom

const FLOOR = Vector2.UP

onready var anim_player := $AnimationPlayer
onready var collect_shape := $PowerUpCollectArea2D/CollisionShape2D
onready var audio_collect := $AudioCollect

var active = false
var speed : float = 1.75 * Globals.UNIT_SIZE
var velocity := Vector2.ZERO
var direction := 1
var gravity := 9.8


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	if active:
		velocity.x = speed * direction
		velocity.y += gravity

		velocity = move_and_slide(velocity, FLOOR)

		if is_on_wall():
			direction *= -1


func activate() -> void:
	anim_player.play("activate")
	yield(anim_player, "animation_finished")
	active = true
	set_physics_process(true)
	collect_shape.set_deferred("disabled", false)


func _on_PowerUpCollectArea2D_body_entered(orima: Orima) -> void:
	match orima.get_powerup_state():
		"Normal":
			visible = false
			collect_shape.set_deferred("disabled", true)
			orima.collect_powerup("Mushroom")
			audio_collect.play()
			yield(audio_collect, "finished")
		"Mushroom", "FireFlower", "Star":
			pass
	queue_free()

