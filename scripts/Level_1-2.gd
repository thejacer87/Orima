extends Node2D

onready var tilemap = $TileMap
onready var brick = load(Globals.brick)


func _ready() -> void:
	var cells = tilemap.get_used_cells()
	for cell in cells:
		var cell_id = tilemap.get_cellv(cell)
		if cell_id != tilemap.INVALID_CELL:
			var tile_name = tilemap.tile_set.tile_get_name(cell_id)
			match tile_name:
				"brick_blue.png 5":
					var new_brick = brick.instance()
					new_brick.position = tilemap.map_to_world(cell) + (tilemap.cell_size / 2)
					new_brick.modulate = "#008787"
					self.add_child(new_brick)

