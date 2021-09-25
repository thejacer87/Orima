extends KinematicBody2D
class_name Orima


onready var animantion_player := $AnimationPlayer
onready var movement_state_machine := $MovementStateMachine
onready var movement_state_label := $MovementStateLabel
onready var powerup_state_machine := $PowerupStateMachine
onready var powerups := $PowerupStateMachine/Powerups
onready var collision := $NormalCollision
onready var run_collision := $RunCollision

var run_shape_vertices


func _ready() -> void:
	Globals.Player = self
	connect("powerup_collected", self, "_on_powerup_collected")

	for powerup in powerups.get_children():
		connect("powerup_collected", powerup, "_on_powerup_collected")


func _physics_process(delta: float) -> void:
#	powerup_state_machine.transition_to("Normal")
	pass


func _process(delta: float) -> void:
	movement_state_label.text = movement_state_machine._state_name


func play_animation(animation: String) -> void:
	animantion_player.play(animation)


func collect_powerup(powerup: String) -> void:
	if powerup == "Mushroom" and powerup_state_machine._state_name == "FireFlower":
		return
	powerup_state_machine.transition_to("Powerups/%s" % [powerup])


func set_run_shape(is_running: bool = false) -> void:
	if is_running:
		run_collision.disabled = false
		collision.disabled = true
	else:
		run_collision.disabled = true
		collision.disabled = false
