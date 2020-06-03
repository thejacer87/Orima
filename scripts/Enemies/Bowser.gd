extends KinematicBody2D

const LEFT_LIMIT := -72
const RIGHT_LIMIT := 32

onready var animation_player := $AnimationPlayer
onready var mouth := $Body/Mouth
onready var fireball := preload("res://scenes/Enemies/Fireball.tscn")

var original_position
var velocity := Vector2()

func _ready() -> void:
	original_position = position

func _physics_process(delta) -> void:
	move_toward_orima(delta)
	velocity.y += 50 * delta
	move_and_slide(velocity, Vector2.UP)
	

func _on_Body_body_entered(player: Player) -> void:
	player.damage()


func _on_FireTimer_random_timeout() -> void:
	var fb_instance = fireball.instance()
	fb_instance.global_position = mouth.global_position
	get_tree().get_root().add_child(fb_instance)


func jump() -> void:
	if is_on_floor():
		print("jump")
		velocity.y -= 250
	
func move_toward_orima(delta) -> void:
	var dest = lerp(position, original_position + Vector2(LEFT_LIMIT, 0), .5) * delta
	position.x = dest.x


func _on_JumpTimer_random_timeout():
	jump()
