extends StaticBody2D

export(bool) var is_hidden = false

onready var hit_anitmation = $AnimationPlayer
onready var sprite = $Sprite
onready var empty_sprite = $EmptySprite
onready var collision = $CollisionShape2D
onready var powerup_collision = $PowerUp/CollisionShape2D

func _ready() -> void:
	if is_hidden:
		sprite.visible = false
		empty_sprite.visible = false
		collision.set_deferred('disabled', true)

func _on_PowerUp_body_entered(body: Node) -> void:
	if body.velocity.y < 0 or not is_hidden:
		hit_anitmation.play("hit")
		sprite.visible = false
		empty_sprite.visible = true
		powerup_collision.set_deferred('disabled', true)
		collision.set_deferred('disabled', false)
