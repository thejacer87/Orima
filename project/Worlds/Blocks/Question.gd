extends Block

onready var sprite := $Sprite

var item setget set_item, get_item
var used_scene = preload("res://Worlds/Blocks/Used.tscn")


func _ready() -> void:
	pass


func set_item(_item: String) -> void:
	item = _item


func get_item() -> Array:
	return item


func hit(collision: KinematicCollision2D) -> void:
	if collision.normal == Vector2.DOWN:
		$AnimationPlayer.play("bump")
		if item:
			var node = load(item).instance()
			node.position = global_position
			get_tree().root.add_child(node)
			node.activate()


func change_to_used() -> void:
	var used = used_scene.instance()
	used.position = position
	used.get_node("Sprite").self_modulate = sprite.self_modulate
	get_parent().add_child(used)
	queue_free()
