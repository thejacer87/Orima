extends Block

onready var block_container := $BlockContainer
var items = [] setget set_items, get_items
var used_scene = preload("res://Worlds/Blocks/Used.tscn")


func _ready() -> void:
	pass


func set_items(item: Node) -> void:
	items.append(item)


func get_items() -> Array:
	return items


func hit(collision: KinematicCollision2D) -> void:
	if collision.normal == Vector2.DOWN:
		$AnimationPlayer.play("bump")
		if items.size():
			var item = items.pop_front()
			item.position = global_position + Vector2(0, -32)
			print(item.name)
			get_tree().root.add_child(item)


func change_to_used() -> void:
	var used = used_scene.instance()
	used.position = position
	get_parent().add_child(used)
	queue_free()
