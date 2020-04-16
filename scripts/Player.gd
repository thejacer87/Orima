extends KinematicBody2D
class_name Player

const FLOOR := Vector2.UP
const ACC := 100

var gravity
var max_jump_velocity
var min_jump_velocity
var speed
var health = 2
var walk_speed = 7 * Globals.UNIT_SIZE
var max_jump_height: = 4.15 * Globals.UNIT_SIZE
var min_jump_height: = 1.25 * Globals.UNIT_SIZE
var jump_duration: = .5

onready var small_shape = $SmallShape
onready var small_sprite = $Sprite
onready var big_shape = $BigShape
onready var big_sprite = $BigSprite
onready var warp_animation = $AnimationPlayer

var velocity: = Vector2()
var on_ground: = true

func _ready() -> void:
	speed = walk_speed
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta: float) -> void:
	update_motion(delta)

func update_motion(delta: float) -> void:
	check_dead()
	run()
	jump()
	move(delta)

func check_dead():
	if health <= 0:
		pass
#		queue_free()

func run() -> void:
	if (on_ground):
		speed = walk_speed * 1.5 if Input.is_action_pressed("run") else walk_speed

func jump() -> void:
	if Input.is_action_just_pressed("jump") and on_ground:
		velocity.y = max_jump_velocity
		on_ground = false
	if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity


func move(delta: float) -> void:
	var friction = false
	if Input.is_action_pressed("right"):
		velocity.x = min(velocity.x + ACC, speed)
	elif Input.is_action_pressed("left"):
		velocity.x = max(velocity.x - ACC, -speed)
	else:
		velocity.x = 0

	on_ground = is_on_floor()

	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, FLOOR)

func warp(direction := Vector2.DOWN):
	var animation_direction = "warp"
	match direction:
		Vector2.UP:
			animation_direction = "warp_up"
		Vector2.RIGHT:
			animation_direction = "warp_right"

	warp_animation.play(animation_direction)

func powerup():
	health = 2
	big_shape.set_deferred('disabled', false)
	big_sprite.visible = true
	small_shape.set_deferred('disabled', true)
	small_sprite.visible = false

func damage():
	big_shape.set_deferred('disabled', true)
	big_sprite.visible = false
	small_shape.set_deferred('disabled', false)
	small_sprite.visible = true
	velocity.y -= 250
	health -= 1
