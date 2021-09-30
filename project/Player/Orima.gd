extends KinematicBody2D
class_name Orima


onready var animantion_player := $AnimationPlayer
onready var movement_state_machine := $MovementStateMachine
onready var movement_state_label := $MovementStateLabel
onready var powerup_state_machine := $PowerupStateMachine
onready var powerups := $PowerupStateMachine/Powerups
onready var collision := $NormalCollision
onready var big_collision := $BigCollision
onready var run_collision := $RunCollision
onready var big_run_collision := $BigRunCollision
onready var remote_transform := $RemoteTransform2D
onready var left_barrier := $LeftBarrier
onready var camera_scene := preload("res://Player/PlayerCamera.tscn")

var run_shape_vertices
var camera


func _ready() -> void:
	Globals.Player = self


func _physics_process(_delta: float) -> void:
	pass


func _process(_delta: float) -> void:
	movement_state_label.text = movement_state_machine._state_name
	_update_camera_limit()


func _update_camera_limit() -> void:
	var new_position = global_position - Vector2(Globals.SCREEN_WIDTH / 2, 0)
	if new_position.x > camera.limit_left:
		camera.limit_left = new_position.x

	left_barrier.position.x = to_local(Vector2(camera.limit_left, 0)).x


func play_animation(animation: String) -> void:
	animantion_player.play(animation)


func collect_powerup(powerup: String) -> void:
	if powerup == "Mushroom" and powerup_state_machine._state_name == "FireFlower":
		return
	powerup_state_machine.transition_to("Powerups/%s" % [powerup])


func set_run_shape(is_running: bool = false) -> void:
	if powerup_state_machine._state_name == "Normal":
		if is_running:
			run_collision.set_deferred("disabled", false)
			collision.set_deferred("disabled", true)
		else:
			run_collision.set_deferred("disabled", true)
			collision.set_deferred("disabled", false)
	else:
		if is_running:
			big_run_collision.disabled = false
			big_collision.set_deferred("disabled", true)
		else:
			big_run_collision.set_deferred("disabled", true)
			big_collision.set_deferred("disabled", false)


func set_current_camera(camera_limits: Dictionary) -> void:
	var new_camera = camera_scene.instance()
	new_camera.limit_left = camera_limits.left
	new_camera.limit_top = camera_limits.top
	new_camera.limit_right = camera_limits.right
	new_camera.limit_bottom = camera_limits.bottom
	new_camera.current = true
	add_child(new_camera)
	if camera:
		camera.queue_free()
	camera = new_camera


func die() -> void:
	get_tree().quit()
