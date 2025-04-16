extends Node2D

@onready var player : Player = $"../"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.change_hitbox_direction.connect( update_direction )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_direction ( new_direction ):
	match new_direction:
		Vector2.LEFT:
			rotation_degrees = 180
		Vector2.DOWN:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 270
		_:
			rotation_degrees = 0
