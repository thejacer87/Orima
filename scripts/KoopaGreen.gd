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


func _process(delta: float) -> void:
	if is_flipped and not is_sliding:
		kick()


func _on_body_entered(player: Player) -> void:
	player.velocity.y = max(player.velocity.y - 350, -350)
	if is_sliding:
		stop()
	flip()


func flip():
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


func kick():
	if $Kick/KickRight.is_colliding() or $Kick/KickLeft.is_colliding():
		print('kicking')
		direction = 1 if $Kick/KickRight.is_colliding() else -1;
		speed = inital_speed * direction * SLIDE_FACTOR
		is_sliding = true
		$Kick/KickLeft.set_deferred("enabled", false)
		$Kick/KickRight.set_deferred("enabled", false)
		yield(get_tree().create_timer(0.1), "timeout")
		enable_collisions()


func stop():
	print('stop')
	is_sliding = false
	remove_collisions()
	$Kick/KickLeft.set_deferred("enabled", true)
	$Kick/KickRight.set_deferred("enabled", true)
	velocity = Vector2.ZERO
	speed = 0
	gravity = 0
	$Squish.play()
	$Timer.start()
	$Timer2.start()
	yield(get_tree().create_timer(0.1), "timeout")
	is_flipped = true


func move_again():
	$AnimationPlayer.play_backwards("flip")
	enable_collisions()
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


func enable_collisions():
	$Terrain.set_deferred("disabled", false)
	$PlayerDamage/CollisionShape2D.set_deferred("disabled", false)
	$TurnAround/CollisionShape2D.set_deferred("disabled", false)
	$Sliding/CollisionShape2D.set_deferred("disabled", false)
	$Kill/CollisionShape2D.set_deferred("disabled", false)
	$Kick/KickLeft.set_deferred("enabled", false)
	$Kick/KickRight.set_deferred("enabled", false)

func remove_collisions():
	.remove_collisions()
	$Kick/KickLeft.set_deferred("enabled", true)
	$Kick/KickRight.set_deferred("enabled", true)
	$Terrain.set_deferred("disabled", false)

