extends Block

onready var coin_scene := preload("res://PickUps/Coin.tscn")

var _coins := 1 setget set_coins


func _ready() -> void:
	pass


func set_coins(coins : int) -> void:
	_coins = coins


func modulate_sprites(color: Color) -> void:
	$Sprite.self_modulate = color
	$UsedSprite.self_modulate = color


func hit(collision: KinematicCollision2D) -> void:
	if collision.normal == Vector2.DOWN:
		if _coins:
			$AnimationPlayer.play("collect")
			var coin = coin_scene.instance()
			add_child(coin)
			coin.activate()
			_coins -= 1

		if not _coins:
			$AnimationPlayer.play("bump")
