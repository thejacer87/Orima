extends Node2D
class_name WorldBase


export(NodePath) var dynamic_tilemap_path
export(Color) var dynamic_tilemap_color
export(Dictionary) var camera_limit = {
	left = -10000000,
	top = -10000000,
	right = 10000000,
	bottom = 10000000
}

var dynamic_tilemap : TileMap


func _ready() -> void:
	Globals.Player.set_current_camera(camera_limit)
	initialize_dynamic_tilemap()


func initialize_dynamic_tilemap() -> void:
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
					var coin = load("res://PickUps/Coin.tscn")
					node.set_items(coin.instance())
				"used":
					node = Globals.USED.instance()
					node.get_node("Sprite").self_modulate = dynamic_tilemap_color

			if node:
				node.position = tilemap.map_to_world(cell) + (tilemap.cell_size / 2) + offset
				add_child(node)

	tilemap.clear()

