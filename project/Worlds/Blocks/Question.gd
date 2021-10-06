extends Block

onready var sprite := $Sprite
onready var used_sprite = $UsedSprite

var item setget set_item


func _ready() -> void:
	pass


func set_item(_item: String) -> void:
	item = _item


func get_item() -> Array:
	return item


func hit(collision: KinematicCollision2D) -> void:
	if collision.normal == Vector2.DOWN:
		$AudioStreamPlayer.play()
		if item:
			$AnimationPlayer.play("bump")
			var node = load(item).instance()
			add_child(node)
			node.activate()
			item = null


func change_to_used() -> void:
	used_sprite.self_modulate = sprite.self_modulate
	used_sprite.visible = true
