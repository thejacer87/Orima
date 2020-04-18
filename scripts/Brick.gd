extends StaticBody2D

export(Texture) var sprite_texture setget set_sprite

onready var hit_anitmation = $AnimationPlayer
onready var sprite = $Sprite
onready var empty_sprite = $EmptySprite
onready var collision = $PowerUp/CollisionShape2D

func _ready() -> void:
	if sprite_texture != null:
		set_sprite(sprite_texture)

func set_sprite(texture):
	sprite.texture = texture

func _on_Break_body_entered(body: Node) -> void:
	# if small,need a player state?
	if (true):
		hit_anitmation.play("hit")
	else:
		hit_anitmation.play("break")
		queue_free()


func _on_BumpKill_body_entered(goomba: Goomba) -> void:
	print('flip kill')
	goomba.flip()
