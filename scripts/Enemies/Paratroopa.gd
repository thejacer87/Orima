extends Node2D

export var move_to := Vector2.DOWN * 7
export var delay := 1.0
export var speed := 3.5

var follow = Vector2.ZERO

onready var body = $Body
onready var tween = $MovementTween

func _ready() -> void:
	_init_tween()


func _init_tween():
	var move_to_units = move_to * Globals.UNIT_SIZE
	var duration = move_to_units.length() / float(speed * Globals.UNIT_SIZE)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to_units, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	tween.interpolate_property(self, "follow", move_to_units, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN, duration + delay * 2)
	tween.start()


func _physics_process(delta):
	body.position = body.position.linear_interpolate(follow, 0.075)


func _on_Kill_body_entered(player: Player) -> void:
	visible = false
	$Squish.play()
	player.velocity.y = min(player.velocity.y - 120, -120)
	var koopa = Globals.Enemies.KOOPA.instance()
	koopa.is_red = true
	koopa.add_to_group("former_paratroopas")
	koopa.position = body.global_position
	koopa.get_node("Kill").set_deferred("monitoring", false)
	get_tree().get_root().add_child(koopa)
	yield(get_tree().create_timer(0.5), "timeout")
	koopa.get_node("Kill").set_deferred("monitoring", true)
	queue_free()
