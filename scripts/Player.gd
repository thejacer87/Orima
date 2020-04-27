extends KinematicBody2D
class_name Player

const FLOOR := Vector2.UP
const ACC := 100

var gravity
var max_jump_velocity
var min_jump_velocity
var speed
var health = 1
var walk_speed = 7 * Globals.UNIT_SIZE
var max_jump_height: = 4.15 * Globals.UNIT_SIZE
var min_jump_height: = 1.25 * Globals.UNIT_SIZE
var jump_duration: = .5
var is_dying := false
var is_sliding := false
var is_warping := false
var velocity := Vector2()
var on_ground := true

onready var small_shape = $SmallShape
onready var small_sprite = $Sprite
onready var big_shape = $BigShape
onready var big_sprite = $BigSprite
onready var animation_player = $AnimationWrapper/AnimationPlayer


func _ready() -> void:
	Globals.Player = self
	speed = walk_speed
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)


func check_dead():
	if health <= 0:
		die()


func run() -> void:
	if (on_ground):
		speed = walk_speed * 1.5 if Input.is_action_pressed("run") else walk_speed


func jump() -> void:
	if not is_sliding:
		if Input.is_action_just_pressed("jump") and on_ground:
			if (true): # todo check state for size
				$SmallJump.play()
			else:
				$BigJump.play()
			velocity.y = max_jump_velocity
			on_ground = false
		if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
			velocity.y = min_jump_velocity


func move(delta: float) -> void:
	var friction = false
	if not is_sliding:
		if Input.is_action_pressed("right"):
			velocity.x = min(velocity.x + ACC, speed)
		elif Input.is_action_pressed("left"):
			velocity.x = max(velocity.x - ACC, -speed)
		else:
			velocity.x = 0

	on_ground = is_on_floor()

#	velocity.y += max(gravity * delta, MAX_FALL_SPEED)
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, FLOOR)


func warp(direction := Vector2.DOWN):
	var animation_direction = "warp"
	match direction:
		Vector2.UP:
			animation_direction = "warp_up"
		Vector2.RIGHT:
			animation_direction = "warp_right"

	animation_player.play(animation_direction)


func one_up():
	Globals.GameState.lives += 1
	$OneUp.play()


func slide():
	is_sliding = true
	velocity = Vector2.ZERO


func powerup():
	health = 2
	$PowerUp.play()

	big_shape.set_deferred('disabled', false)
	big_sprite.visible = true
	small_shape.set_deferred('disabled', true)
	small_sprite.visible = false


func damage():
	big_shape.set_deferred('disabled', true)
	big_sprite.visible = false
	small_shape.set_deferred('disabled', false)
	small_sprite.visible = true
	health -= 1
	check_dead()


func die():
	if not is_dying:
		is_dying = true
		if health <= 0:
			animation_player.play("dead")
		Globals.GameState.die()
