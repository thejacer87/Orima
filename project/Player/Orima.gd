extends KinematicBody2D
class_name Orima

onready var state_machine := $StateMachine
onready var move_state := $StateMachine/Move
onready var state_label := $StateLabel

func _ready() -> void:
	Globals.Player = self


func _process(delta: float) -> void:
	state_label.text = state_machine._state_name
