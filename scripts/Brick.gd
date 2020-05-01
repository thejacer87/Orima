extends StaticBody2D

export(Texture) var sprite_texture setget set_sprite

onready var hit_anitmation = $AnimationPlayer
onready var sprite = $Sprite
onready var empty_sprite = $EmptySprite
onready var collision = $PowerUp/CollisionShape2D
onready var audio_break = $AudioBreak
onready var audio_bump = $AudioBump

func _ready() -> void:
	if sprite_texture != null:
		set_sprite(sprite_texture)


func set_sprite(texture):
	sprite.texture = texture


func _on_BumpKill_body_entered(body: Node) -> void:
	body.bump()


func _on_BlockHitbox_bump(player: Player) -> void:
	hit_anitmation.play("hit")
	if Globals.GameState.powerup == Globals.GameState.powerup_states.SMALL:
		audio_bump.play()
	else:
		yield(get_tree().create_timer(0.05), "timeout")
		hit_anitmation.play("break")
		audio_break.play()
		yield(get_tree().create_timer(0.2), "timeout")
		queue_free()
