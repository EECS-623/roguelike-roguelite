extends Node2D
@export var s_player: PackedScene = preload("res://Entities/Player/player.tscn")
@export var s_snake: PackedScene 


var player = Node2D
var snake = Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = s_player.instantiate()
	get_tree().current_scene.add_child(player)
	
	snake = s_snake.instantiate()
	get_tree().current_scene.add_child(snake)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	snake.chase_player(player.global_position)
	pass
