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
	for item in items.get_children():
		item.z_index = -1
		item.visible = false
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
			# Make entire block visible in case it was a hidden block
			visible = true

			var item_count = items.get_child_count()
			var item = items.get_child(0)
			if item != null:
				# Doing this so you can't keep hitting the mushroom item block
				# before actually getting the mushroom.
				var old_position = item.global_position
				var grandparent = item.get_parent().get_parent()
				items.remove_child(item)
				grandparent.add_child(item)
				item.global_position = old_position
				item.visible = true
				item.activate()
			if item_count <= 1:
				sprite.visible = false
				is_empty = true
				empty_sprite.visible = true
				bump_kill_collision.set_deferred('disabled', true)
				collision.set_deferred('disabled', false)
