extends Enemy
class_name KoopaGreen

const SLIDE_FACTOR := 7

var is_sliding := false
var inital_velocity : Vector2
var inital_gravity : float
var inital_speed : float
var is_flipped := false
var is_stopped := false

onready var audio_kick = $AudioKick
onready var audio_squish = $AudioSquish
onready var audio_bump = $AudioBump
onready var kick_right = $Kick/KickRight
onready var kick_left = $Kick/KickLeft

func _ready() -> void:
	inital_speed = speed
	inital_gravity = gravity
	inital_velocity = velocity


func _physics_process(delta: float) -> void:
	if is_flipped and not is_sliding:
		kick()

	if is_sliding and is_on_wall():
		audio_bump.play()


func _on_body_entered(player: Player) -> void:
	player.velocity.y = max(player.velocity.y - 350, -350)
	if is_sliding:
		stop()
	flip()


func kick():
	if (kick_right.is_colliding() or kick_left.is_colliding()) and is_stopped and not is_sliding:
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
	$AnimationPlayer.play("flip")
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
	$AnimationPlayer.stop()
	audio_squish.play()
	$Timer.start()
	$Timer2.start()
	is_flipped = true
	yield(get_tree().create_timer(0.3), "timeout")
	is_stopped = true
	kick_left.set_deferred("enabled", true)
	kick_right.set_deferred("enabled", true)


func move_again():
	$AnimationPlayer.play_backwards("flip")
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
		$AnimationPlayer.play("shaking")


func _on_Sliding_body_entered(body: Node) -> void:
	if is_sliding:
		if "Goomba" in body.name or "KoopaGreen" in body.name or "KoopaRed" in body.name:
			$AudioKick.play()
			body.bump()
		if "Player" in body.name:
			body.damage()


func _on_PlayerDamage_body_entered(body: Node) -> void:
	if not is_dead and not is_sliding:
		if "Player" in body.name:
			body.damage()


func enable_collisions():
	$Terrain.set_deferred("disabled", false)
	$Kill/CollisionShape2D.set_deferred("disabled", false)
	$Sliding/CollisionShape2D.set_deferred("disabled", false)
	kick_left.set_deferred("enabled", false)
	kick_right.set_deferred("enabled", false)


func remove_collisions():
	.remove_collisions()
	kick_left.set_deferred("enabled", true)
	kick_right.set_deferred("enabled", true)
	$Terrain.set_deferred("disabled", false)
	$Sliding/CollisionShape2D.set_deferred("disabled", true)
