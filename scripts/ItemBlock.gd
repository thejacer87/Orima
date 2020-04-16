extends StaticBody2D

onready var hit_anitmation = $AnimationPlayer
onready var sprite = $Sprite
onready var empty_sprite = $EmptySprite
onready var collision = $PowerUp/CollisionShape2D

func _on_PowerUp_body_entered(body: Node) -> void:
	hit_anitmation.play("hit")
	sprite.visible = false
	empty_sprite.visible = true
	collision.set_deferred('disabled', true)
