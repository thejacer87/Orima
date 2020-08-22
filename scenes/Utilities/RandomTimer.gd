extends Timer

signal random_timeout

export(float, 0, 600) var min_time := 1
export(float, 0, 600) var max_time := 3

func _ready() -> void:
	init_rand()


func init_rand() -> void:
	yield(get_tree().create_timer(rand_range(min_time, max_time)), "timeout")
	emit_signal("random_timeout")
	init_rand()
