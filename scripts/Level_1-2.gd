extends Node2D

onready var dynamic_tilemap = $DynamicTileMap

func _ready() -> void:
	var cells = dynamic_tilemap.get_used_cells()
	for cell in cells:
		var cell_id = dynamic_tilemap.get_cellv(cell)
		if cell_id != dynamic_tilemap.INVALID_CELL:
			var tile_name = dynamic_tilemap.tile_set.tile_get_name(cell_id)
			var child
			match tile_name:
				"brick.png 0":
					child = Globals.BRICK.instance()
					child.modulate = "#008787"
				"block.png 1":
					child = Globals.BLOCK.instance()
					var coin = Globals.COIN.instance()
					coin.z_index = -1
					child.get_node("Items").add_child(coin)
				"mushroom.png 2":
					child = Globals.BLOCK.instance()
					var mushroom = Globals.MUSHROOM.instance()
					mushroom.z_index = -1
					child.get_node("Items").add_child(mushroom)
				"piranha_open.png 4":
					child = Globals.Enemies.PIRANHA.instance()

			if child != null:
				child.position = dynamic_tilemap.map_to_world(cell) + (dynamic_tilemap.cell_size / 2)
				self.add_child(child)
	dynamic_tilemap.clear()
