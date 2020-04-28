extends StaticBody2D

export(bool) var is_hidden = false

onready var hit_anitmation = $AnimationPlayer
onready var sprite = $Sprite
onready var empty_sprite = $EmptySprite
onready var collision = $CollisionShape2D
onready var block_hitbox = $BlockHitbox/CollisionShape2D
onready var bump_kill_collision = $BumpKill/CollisionShape2D
onready var items = $Items
onready var audio_bump = $AudioBump

var is_empty := false

func _ready() -> void:
	if is_hidden:
		sprite.visible = false
		empty_sprite.visible = false
		collision.set_deferred('disabled', true)


func _on_BumpKill_body_entered(body: Node) -> void:
	body.bump()


func _on_BlockHitbox_bump(player: Player) -> void:
	if is_empty:
		audio_bump.play()
	else:
		if player.velocity.y < 0 or not is_hidden:
			hit_anitmation.play("hit")
			audio_bump.play()
			for item in items.get_children():
				item.activate()
			# Make entire block visible in case it was a hidden block
			visible = true
			sprite.visible = false
			is_empty = true
			empty_sprite.visible = true
			bump_kill_collision.set_deferred('disabled', true)
			collision.set_deferred('disabled', false)
