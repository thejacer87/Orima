extends Enemy
class_name Koopa

const SLIDE_FACTOR := 7

var is_sliding := false

var inital_velocity : Vector2
var inital_gravity : float
var inital_speed : float


func _ready() -> void:
	._ready()
	inital_speed = speed
	inital_gravity = gravity
	inital_velocity = velocity


func _on_body_entered(player: Player) -> void:
	is_flipped = true
	print(is_flipped)
	player.velocity.y = max(player.velocity.y - 350, -350)
	print('koopa hit: %d' % OS.get_ticks_msec())
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
	$Kick/CollisionShape2D.set_deferred('disabled', false)


func move_again():
	$AnimationPlayer.play_backwards("flip")
	$Kick/CollisionShape2D.set_deferred('disabled', true)
	enable_collisions()
	speed = inital_speed * direction
	gravity = inital_gravity
	velocity = inital_velocity


func _on_Timer_timeout() -> void:
	if not is_sliding:
		move_again()


func _on_Timer2_timeout() -> void:
	if not is_sliding:
		$AnimationPlayer.play("shaking")


func _on_Kick_body_entered(player: Player) -> void:
	var dir = -1 # get from side of shell player hit
	$Kick/CollisionShape2D.set_deferred('disabled', true)
	speed = inital_speed * dir * SLIDE_FACTOR
	gravity = inital_gravity
	velocity = inital_velocity
	is_sliding = true
	yield(get_tree().create_timer(0.1), "timeout")
	$Sliding/CollisionShape2D.set_deferred('disabled', false)


func _on_Sliding_body_entered(body: Node) -> void:
	if is_sliding:
		if "Player" in body.name:
			body.damage()
		elif "Goomba" in body.name:
			$SlideKill.play()
			body.bump()
		else:
			pass


func enable_collisions():
	$Terrain.set_deferred("disabled", false)
	$PlayerDamage/CollisionShape2D.set_deferred("disabled", false)
	$TurnAround/CollisionShape2D.set_deferred("disabled", false)
	$Kill/CollisionShape2D.set_deferred("disabled", false)

func remove_collisions():
	.remove_collisions()
	$Terrain.set_deferred("disabled", false)

