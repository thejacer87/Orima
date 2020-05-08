extends KinematicBody2D

const ANIM_HEIGHT := 24

var pause := false
var pipe_down_finished := true
var pipe_up_finished := false
onready var tween_up = $TweenUp
onready var tween_down = $TweenDown

func _ready() -> void:
	pipe_up()


func _on_DetectionZone_body_entered(body: Node) -> void:
	pause = true


func _on_DetectionZone_body_exited(body: Node) -> void:
	pause = false
	if pipe_down_finished and pipe_up_finished:
		pipe_up()


func _on_TweenUp_tween_completed(object: Object, key: NodePath) -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	pipe_up_finished = true
	pipe_down()


func _on_TweenDown_tween_completed(object: Object, key: NodePath) -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	pipe_down_finished = true
	pipe_up()


func pipe_up():
	if not pause:
		pipe_up_finished = false
		tween_up.interpolate_property(self, "position",
			position, Vector2(position.x, position.y - ANIM_HEIGHT), 0.75)
		tween_up.start()


func pipe_down():
	pipe_down_finished = false
	tween_down.interpolate_property(self, "position",
		position, Vector2(position.x, position.y + ANIM_HEIGHT), 0.75)
	tween_down.start()
