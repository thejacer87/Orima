extends StaticBody2D

const SPEED := -50

onready var animation_player := $AnimationPlayer
onready var audio_stream_player := $AudioStreamPlayer

func _ready() -> void:
	animation_player.play("move")
	audio_stream_player.play()

func _physics_process(delta) -> void:
	position.x += SPEED * delta

func _on_Fireball_body_entered(player: Player) -> void:
	player.damage()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
