extends Node

const UNIT_SIZE = 16
const SCREEN_WIDTH = 256
const FLOOR = Vector2.UP
const COIN = preload("res://PickUps/Coin.tscn")
const BRICK = preload("res://Worlds/Blocks/Brick.tscn")
const BRICK_COIN = preload("res://Worlds/Blocks/BrickCoin.tscn")
const QUESTION = preload("res://Worlds/Blocks/Question.tscn")
const USED = preload("res://Worlds/Blocks/Used.tscn")
#const BLOCK = preload("res://scenes/ItemBlock.tscn")
#const FIREBAR = preload("res://scenes/Terrain/FireBar.tscn")
#const MUSHROOM = preload("res://scenes/Mushroom.tscn")
#const MUSHROOM_1UP = preload("res://scenes/Mushroom1Up.tscn")


var Player
