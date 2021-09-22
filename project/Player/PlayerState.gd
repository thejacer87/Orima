class_name PlayerState
extends State

var player: Orima


func _ready() -> void:
	yield(owner, "ready")
	player = owner
