extends Enemy
class_name Koopa

const SLIDE_FACTOR := 7

export var is_red := false
export var was_paratroopa := false

var is_sliding := false
var inital_velocity : Vector2
var inital_gravity : float
var inital_speed : float
var is_flipped := false
var is_stopped := false

onready var sprite = $Sprite
onready var audio_kick = $AudioKick
onready var audio_squish = $AudioSquish
onready var audio_bump = $AudioBump
onready var kick_right = $Kick/KickRight
onready var kick_left = $Kick/KickLeft
onready var sliding_collision = $Sliding/CollisionShape2D
onready var ledge_turnaround = $LedgeTurnaround
onready var animation_player = $AnimationPlayer


func _ready() -> void:
	inital_speed = speed
	inital_gravity = gravity
	inital_velocity = velocity
	if is_red:
		sprite.set_texture(load(Globals.sprites.koopa_red))
		ledge_turnaround.enabled = true


func _physics_process(_delta: float) -> void:
	if is_flipped and not is_sliding:
		kick()

	if is_sliding and is_on_wall():
		audio_bump.play()

	if is_red and not is_sliding and not ledge_turnaround.is_colliding() and is_on_floor():
		direction *= -1


func _on_body_entered(player: Player) -> void:
	player.kill_bump()
	if is_sliding:
		stop()
	else:
		flip()


func kick():
	if (kick_right.is_colliding() or kick_left.is_colliding()) and is_stopped:
		direction = 1 if $Kick/KickRight.is_colliding() else -1;
		speed = inital_speed * SLIDE_FACTOR
		is_sliding = true
		is_stopped = false
		gravity = inital_gravity
		audio_kick.play()
		kick_left.set_deferred("enabled", false)
		kick_right.set_deferred("enabled", false)
		$Timer.stop()
		$Timer2.stop()
		yield(get_tree().create_timer(0.1), "timeout")
		enable_collisions()
		yield(get_tree().create_timer(0.8), "timeout")
		$PlayerDamage/CollisionShape2D.set_deferred("disabled", false)


func flip():
	remove_collisions()
	velocity = Vector2.ZERO
	speed = 0
	gravity = 0
	animation_player.play("flip")
	audio_squish.play()
	$Timer.start()
	$Timer2.start()
	yield(get_tree().create_timer(0.1), "timeout")
	is_flipped = true
	is_stopped = true


func stop():
	remove_collisions()
	$TurnAround/CollisionShape2D.set_deferred("disabled", false)
	is_sliding = false
	velocity = Vector2.ZERO
	speed = 0
	gravity = 0
	animation_player.stop()
	audio_squish.play()
	$Timer.start()
	$Timer2.start()
	is_flipped = true
	yield(get_tree().create_timer(0.3), "timeout")
	is_stopped = true
	kick_left.set_deferred("enabled", true)
	kick_right.set_deferred("enabled", true)


func bump():
	velocity.y = min(200, velocity.y - 200)
	animation_player.play("bump")
	.remove_collisions()
	yield(get_tree().create_timer(3), "timeout")
	die()


func move_again():
	animation_player.play_backwards("flip")
	enable_collisions()
	# this fucks things up for the kick if it's in `enable_collisions()`
	$TurnAround/CollisionShape2D.set_deferred("disabled", false)
	$Sprite.position = Vector2.ZERO
	speed = inital_speed * direction
	gravity = inital_gravity
	velocity = inital_velocity


func _on_Timer_timeout() -> void:
	if not is_sliding:
		move_again()


func _on_Timer2_timeout() -> void:
	if not is_sliding:
		animation_player.play("shaking")


func _on_Sliding_body_entered(body: Node) -> void:
	if body != self and is_sliding:
		if "Goomba" in body.name or "Koopa" in body.name:
			$AudioKick.play()
			body.bump()


func _on_PlayerDamage_body_entered(body: Node) -> void:
	if not is_dead and not is_sliding:
		if "Player" in body.name:
			body.damage()


func enable_collisions():
	$Terrain.set_deferred("disabled", false)
	$Kill/CollisionShape2D.set_deferred("disabled", false)
	sliding_collision.set_deferred("disabled", false)
	kick_left.set_deferred("enabled", false)
	kick_right.set_deferred("enabled", false)


func remove_collisions():
	.remove_collisions()
	kick_left.set_deferred("enabled", true)
	kick_right.set_deferred("enabled", true)
	$Terrain.set_deferred("disabled", false)
	sliding_collision.set_deferred("disabled", true)
