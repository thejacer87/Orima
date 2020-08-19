extends Node2D

var checkpoint_reached = false
var win = false

onready var player = $Player
onready var dynamic_tilemap = $DynamicTileMap
onready var bridge = $Bridge
onready var bowser = $Bowser



func _ready() -> void:
	Globals.convert_tilecells_to_nodes(self, dynamic_tilemap)
	Globals.GameState.update_GUI()
	Globals.GameMusic.play(Globals.music["castle"])
	player.position.y = 104
	player.position.x = 12


func _on_BridgeSwitch_body_entered(body: Node) -> void:
	if not win:
		win = true
		bowser.stop_shooting()
		bridge.queue_free()
		yield(get_tree().create_timer(3), "timeout")
		bowser.die()
		Globals.GameMusic.stop()
		Globals.goto_level(Globals.scenes["winner"], Vector2.ZERO)
