class_name RaycastComponent extends RayCast2D

@export var raycast_length: float
var dir_to_player
var angle
var player: Player
var on_player: bool 

signal player_collision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = PlayerManager.player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !player:
		player = PlayerManager.player
	if player and raycast_length != 0:
		dir_to_player = (player.global_position - global_position).normalized()
		target_position = dir_to_player * raycast_length
		if get_collider() == player:
			player_collision.emit()
			on_player = true
		else:
			on_player = false
