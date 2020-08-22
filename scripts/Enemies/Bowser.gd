extends KinematicBody2D


onready var animation_player := $AnimationPlayer
onready var mouth := $Body/Mouth
onready var fire_timer := $FireTimer
onready var jump_timer := $JumpTimer
onready var fireball := preload("res://scenes/Enemies/Fireball.tscn")

var left_limit : Vector2
var right_limit : Vector2
var velocity := Vector2()
var gravity
var max_jump_velocity
var min_jump_velocity
var speed
var walk_speed : float = 7.0 * Globals.UNIT_SIZE
var max_jump_height : float = 2.25 * Globals.UNIT_SIZE
var jump_duration := .75

func _ready() -> void:
	right_limit = position
	left_limit = right_limit + Vector2(-72, 0)
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)


func _physics_process(delta) -> void:
	move_horizontal(delta)

	velocity.y = velocity.y + gravity * delta
	move_and_slide(velocity, Vector2.UP)


func _on_Body_body_entered(player: Player) -> void:
	player.damage()


func _on_FireTimer_random_timeout() -> void:
	var fb_instance = fireball.instance()
	fb_instance.global_position = mouth.global_position
	get_tree().get_root().add_child(fb_instance)


func jump() -> void:
	if is_on_floor():
		velocity.y = max_jump_velocity


func move_horizontal(delta) -> void:
#	var dest = lerp(position, right_limit + Vector2(left_limit, 0), .5) * delta
#	position.x = dest.x
	pass


func stop_shooting() -> void:
	fire_timer.queue_free()
	jump_timer.queue_free()


func die() -> void:
	queue_free()

func _on_JumpTimer_random_timeout():
	jump()
