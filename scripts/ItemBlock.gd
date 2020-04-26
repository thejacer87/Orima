extends StaticBody2D

export(bool) var is_hidden = false

onready var hit_anitmation = $AnimationPlayer
onready var sprite = $Sprite
onready var empty_sprite = $EmptySprite
onready var collision = $CollisionShape2D
onready var block_hitbox = $BlockHitbox/CollisionShape2D
onready var bump_kill_collision = $BumpKill/CollisionShape2D
onready var items = $Items


func _ready() -> void:
	if is_hidden:
		sprite.visible = false
		empty_sprite.visible = false
		collision.set_deferred('disabled', true)



func _on_BumpKill_body_entered(body: Node) -> void:
	print(body.name)
	body.bump()


func _on_BlockHitbox_bump(body: Node) -> void:
	print(body.name)
	if body.velocity.y < 0 or not is_hidden:
		hit_anitmation.play("hit")
		for item in items.get_children():
			item.activate()
		# Make entire block visible in case it was a hidden block
		visible = true
		sprite.visible = false
		empty_sprite.visible = true
		block_hitbox.set_deferred('disabled', true)
		bump_kill_collision.set_deferred('disabled', true)
		collision.set_deferred('disabled', false)
