extends KinematicBody2D
class_name Player

const FLOOR := Vector2.UP
const ACC := 100
const RUN_SCALE := 1.5
const SMALL_SHAPE := Vector2(7.75, 7.5)
const BIG_SHAPE := Vector2(15.5, 7.5)

var gravity
var max_jump_velocity
var min_jump_velocity
var speed
var health := 1
var walk_speed : float = 7.0 * Globals.UNIT_SIZE
var max_jump_height : float = 4.15 * Globals.UNIT_SIZE
var min_jump_height : float = 1.25 * Globals.UNIT_SIZE
var jump_duration := .5
var is_dying := false
var is_sliding := false
var is_warping := false
var velocity := Vector2()

onready var small_hurtbox = $SmallHurtbox
onready var big_hurtbox = $BigHurtbox
onready var mario_shape = $MarioShape
onready var small_sprite = $Sprite
onready var big_sprite = $BigSprite
onready var animation_player = $AnimationWrapper/AnimationPlayer
onready var audio_stun = $AudioStun


func _ready() -> void:
	Globals.Player = self
	animation_player.play("idle")
	if Globals.GameState.powerup == Globals.GameState.powerup_states.BIG:
		self.powerup()
	speed = walk_speed
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)


func check_dead() -> bool:
	if health <= 0:
		die()
		return true
	return false


func run() -> void:
	if is_on_floor():
		speed = walk_speed * RUN_SCALE if Input.is_action_pressed("run") else walk_speed


func jump() -> void:
	if not is_sliding:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			if Globals.GameState.powerup == Globals.GameState.powerup_states.SMALL:
				$SmallJump.play()
			else:
				$BigJump.play()
			velocity.y = max_jump_velocity
		if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
			velocity.y = min_jump_velocity


func move(delta: float) -> void:
	if not is_sliding:
		if Input.is_action_pressed("right"):
			velocity.x = min(velocity.x + ACC, speed)
		elif Input.is_action_pressed("left"):
			velocity.x = max(velocity.x - ACC, -speed)
		else:
			velocity.x = 0

	velocity.y += gravity * delta

	var snap = Vector2.DOWN * 32 if not is_on_floor() else Vector2.ZERO
#	velocity = move_and_slide_with_snap(velocity, snap, FLOOR, true)
	velocity = move_and_slide(velocity, FLOOR, true)


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


func slide():
	is_sliding = true
	velocity = Vector2.ZERO


func powerup():
	health = 2
	set_hitbox_size(Globals.GameState.powerup_states.BIG)
	big_hurtbox.set_deferred("monitoring", true)
	big_sprite.visible = true
	small_hurtbox.set_deferred("monitoring", false)
	small_sprite.visible = false
	Globals.GameState.powerup = Globals.GameState.powerup_states.BIG


func damage():
	health -= 1
	if not check_dead():
		big_sprite.visible = false
		small_sprite.visible = true
		if Globals.GameState.powerup == Globals.GameState.powerup_states.BIG:
			Globals.GameState.powerup = Globals.GameState.powerup_states.SMALL
			set_hitbox_size(Globals.GameState.powerup_states.SMALL)
			big_hurtbox.set_deferred("monitoring", false)
			small_hurtbox.start_invincibility(2.5)
		animation_player.play("stun")
		audio_stun.play()


func die():
	if not is_dying:
		is_dying = true
		if health <= 0:
			animation_player.play("dead")
		Globals.GameState.die()


func _on_SmallHurtbox_area_entered(area: Area2D) -> void:
	self.damage()


func _on_BigHurtbox_area_entered(area: Area2D) -> void:
	self.damage()


func _on_SmallHurtbox_invincibility_ended():
	animation_player.play("idle")


func set_hitbox_size(size):
	if size == Globals.GameState.powerup_states.BIG:
		mario_shape.position.y = -7.5
		mario_shape.get_shape().set_extents(BIG_SHAPE)
	else:
		mario_shape.position.y = -0.25
		mario_shape.get_shape().set_extents(SMALL_SHAPE)
