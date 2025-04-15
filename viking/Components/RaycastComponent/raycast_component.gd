class_name RaycastComponent extends RayCast2D

@export var player: Player

signal player_collision
var dir_to_player
var angle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# need to find a way to get the player from scene or a global instance of player
	dir_to_player = (player.global_position - global_position).normalized()
	if get_collider() == player:
		player_collision.emit()
