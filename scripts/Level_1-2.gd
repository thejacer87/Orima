extends Node2D

onready var dynamic_tilemap = $DynamicTileMap

func _ready() -> void:
	var cells = dynamic_tilemap.get_used_cells()
	for cell in cells:
		var cell_id = dynamic_tilemap.get_cellv(cell)
		if cell_id != dynamic_tilemap.INVALID_CELL:
			var tile_name = dynamic_tilemap.tile_set.tile_get_name(cell_id)
			var child
			var offset = Vector2.ZERO
			match tile_name:
				"brick.png 0":
					child = Globals.BRICK.instance()
					child.modulate = "#008787"
				"block.png 1":
					child = Globals.BLOCK.instance()
					child.modulate = "#008787"
					child.get_node("Items").add_child(Globals.COIN.instance())
				"block_empty.png 10":
					child = Globals.BLOCK.instance()
					child.modulate = "#008787"
					child.get_node("Sprite").visible = false
					child.get_node("Items").add_child(Globals.COIN.instance())
				"mushroom.png 2":
					child = Globals.BLOCK.instance()
					child.modulate = "#008787"
					child.get_node("Sprite").set_texture(load(Globals.sprites.brick))
					child.get_node("Items").add_child(Globals.MUSHROOM.instance())
				"mushroom_1up.png 8":
					child = Globals.BLOCK.instance()
					child.modulate = "#008787"
					child.get_node("Sprite").set_texture(load(Globals.sprites.brick))
					child.get_node("Items").add_child(Globals.MUSHROOM_1UP.instance())
				"coin.png 3":
					child = Globals.COIN.instance()
				"piranha_open.png 4":
					child = Globals.Enemies.PIRANHA.instance()
					offset = Vector2(8, 0)
				"goomba.png 5":
					child = Globals.Enemies.GOOMBA.instance()
				"koopa_green.png 6":
					child = Globals.Enemies.KOOPA_GREEN.instance()
				"koopa_red.png 7":
					child = Globals.Enemies.KOOPA_RED.instance()
				"cloud.png 9":
					child = Globals.BLOCK.instance()
					child.get_node("Sprite").set_texture(load(Globals.sprites.brick))
					child.modulate = "#008787"
					for n in range(5):
						child.get_node("Items").add_child(Globals.COIN.instance())

			if child != null:
				child.position = dynamic_tilemap.map_to_world(cell) + (dynamic_tilemap.cell_size / 2) + offset
				self.add_child(child)
	dynamic_tilemap.clear()
