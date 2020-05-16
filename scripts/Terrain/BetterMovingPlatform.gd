extends Node2D

export var move_to := Vector2.RIGHT * 192
export var delay := 1.0
export var distance := 128
export var speed := 3.5

var follow = Vector2.ZERO

onready var platform = $Platform
onready var tween = $MovementTween

func _ready() -> void:
	_init_tween()


func _init_tween():
	var duration = move_to.length() / float(speed * Globals.UNIT_SIZE)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + delay * 2)
	tween.start()


func _physics_process(delta):
	platform.position = platform.position.linear_interpolate(follow, 0.075)
