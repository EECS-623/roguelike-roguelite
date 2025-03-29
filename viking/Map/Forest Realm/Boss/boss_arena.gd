extends Node2D
@export var player: PackedScene = preload("res://Entity/Player/player.tscn")
@export var enemy: PackedScene = preload("res://Map/Forest Realm/Boss/snake_boss.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_player = player.instantiate()
	get_tree().current_scene.add_child(my_player)
	my_player.position = global_position
	
	var the_enemy = enemy.instantiate()
	get_tree().current_scene.add_child(the_enemy)
	the_enemy.position = global_position + Vector2(700, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
