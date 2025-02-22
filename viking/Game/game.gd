extends Node2D
@export var player: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_player = player.instantiate()
	add_child(new_player)
	new_player.set_position(Vector2(0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
