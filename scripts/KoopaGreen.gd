extends Enemy
class_name Koopa

const SLIDE_FACTOR := 7

var is_sliding := false

var inital_velocity : Vector2
var inital_gravity : float
var inital_speed : float
var is_flipped := false


func _ready() -> void:
	._ready()
	inital_speed = speed
	inital_gravity = gravity
	inital_velocity = velocity

# didn't override physics_process cuz passing the delta seemed to cause issues
func _process(delta: float) -> void:
#	$States.text = """
#	 sliding: %s\n
#	 direction: %s\n
#	 speed: %s\n
#	 velocity: %s %s\n
#	 flipped: %s""" % [
#		is_sliding,
#		direction,
#		speed,
#		velocity.x, velocity.y,
#		is_flipped,
#		]
#
#	$Collisions.text = """
#	 kill: %s\n
#	 Turnaround: %s\n
#	 PlayerDamage: %s\n
#	 Terrain: %s\n
#	 Sliding: %s\n
#	 Kick: %s %s""" % [
#		!$Kill/CollisionShape2D.disabled,
#		!$TurnAround/CollisionShape2D.disabled,
#		!$PlayerDamage/CollisionShape2D.disabled,
#		!$Terrain.disabled,
#		!$Sliding/CollisionShape2D.disabled,
#		$Kick/KickLeft.enabled,
#		$Kick/KickRight.enabled,
#		]
	if is_flipped and not is_sliding:
		kick()


func _on_body_entered(player: Player) -> void:
	player.velocity.y = max(player.velocity.y - 350, -350)
	if is_sliding:
		stop()
	flip()


func kick():
	if $Kick/KickRight.is_colliding() or $Kick/KickLeft.is_colliding() and not is_sliding:
		direction = 1 if $Kick/KickRight.is_colliding() else -1;
		speed = inital_speed * direction * SLIDE_FACTOR
		is_sliding = true
		$Kick/KickLeft.set_deferred("enabled", false)
		$Kick/KickRight.set_deferred("enabled", false)
		$Timer.stop()
		$Timer2.stop()
		yield(get_tree().create_timer(0.1), "timeout")
		enable_collisions()


func flip():
	print('stop')
	remove_collisions()
	velocity = Vector2.ZERO
	speed = 0
	gravity = 0
	$AnimationPlayer.play("flip")
	$Squish.play()
	$Timer.start()
	$Timer2.start()
	yield(get_tree().create_timer(0.1), "timeout")
	is_flipped = true


func stop():
	print('stop')
	remove_collisions()
	$TurnAround/CollisionShape2D.set_deferred("disabled", false)
	is_sliding = false
	velocity = Vector2.ZERO
	speed = 0
	gravity = 0
	$AnimationPlayer.stop()
	$Squish.play()
	$Timer.start()
	$Timer2.start()
	yield(get_tree().create_timer(0.1), "timeout")
	$Kick/KickLeft.set_deferred("enabled", true)
	$Kick/KickRight.set_deferred("enabled", true)
	is_flipped = true


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
	print('timer out')
	if not is_sliding:
		move_again()


func _on_Timer2_timeout() -> void:
	print('timer2 out')
	if not is_sliding:
		$AnimationPlayer.play("shaking")


func _on_Sliding_body_entered(body: Node) -> void:
	if is_sliding:
		if "Goomba" in body.name:
			$SlideKill.play()
			body.bump()
		if "Player" in body.name:
			body.damage()

func _on_PlayerDamage_body_entered(body: Node) -> void:
	if not is_dead and not is_sliding:
		if "Player" in body.name:
			body.damage()

func enable_collisions():
	$Terrain.set_deferred("disabled", false)
	$PlayerDamage/CollisionShape2D.set_deferred("disabled", false)
	$Kill/CollisionShape2D.set_deferred("disabled", false)
	$Sliding/CollisionShape2D.set_deferred("disabled", false)
	$Kick/KickLeft.set_deferred("enabled", false)
	$Kick/KickRight.set_deferred("enabled", false)

func remove_collisions():
	.remove_collisions()
	$Kick/KickLeft.set_deferred("enabled", true)
	$Kick/KickRight.set_deferred("enabled", true)
	$Terrain.set_deferred("disabled", false)
	$Sliding/CollisionShape2D.set_deferred("disabled", true)
