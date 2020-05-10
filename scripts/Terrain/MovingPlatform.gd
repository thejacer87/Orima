extends Path2D

export var delay := 0.0

onready var follow = $MovingPlatformPathFollow2D
onready var speed = Globals.UNIT_SIZE * 3.5

func _ready() -> void:
	set_physics_process(false)
	yield(get_tree().create_timer(delay), "timeout")
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	follow.set_offset(follow.get_offset() + speed * delta)
