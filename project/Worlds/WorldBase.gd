extends Node2D
class_name WorldBase


export(Vector2) var starting_position
export(NodePath) var dynamic_tilemap_path
export(Color) var dynamic_tilemap_color
export(Dictionary) var camera_limit = {
	left = -10000000,
	top = -10000000,
	right = 10000000,
	bottom = 10000000
}


func _ready() -> void:
	init_dynamic_tilemap()
	init_orima()


func init_orima() -> void:
	var orima = Globals.Player
	if not orima:
		orima = load("res://Player/Orima.tscn").instance()
	orima.position = starting_position
	add_child(orima)
	orima.set_current_camera(camera_limit)


func init_dynamic_tilemap() -> void:
	var tilemap = get_node(dynamic_tilemap_path)
	if not tilemap:
		return

	var cells = tilemap.get_used_cells()

	for cell in cells:
		var cell_id = tilemap.get_cellv(cell)

		if not cell_id == tilemap.INVALID_CELL:
			var node
			var offset = Vector2.ZERO
			var tile_name = tilemap.tile_set.tile_get_name(cell_id)

			match tile_name:
				"brick":
					node = Globals.BRICK.instance()
					node.get_node("Sprite").self_modulate = dynamic_tilemap_color
				"question":
					node = Globals.QUESTION.instance()
					node.get_node("Sprite").self_modulate = dynamic_tilemap_color
					node.set_item("res://PickUps/Coin.tscn")
				"mushroom":
					node = Globals.QUESTION.instance()
					node.get_node("Sprite").self_modulate = dynamic_tilemap_color
					node.set_item("res://PowerUps/Mushroom/Mushroom.tscn")
				"used":
					node = Globals.USED.instance()
					node.get_node("Sprite").self_modulate = dynamic_tilemap_color
				"coin":
					node = Globals.COIN.instance()

			if node:
				node.position = tilemap.map_to_world(cell) + (tilemap.cell_size / 2) + offset
				add_child(node)

	tilemap.clear()

