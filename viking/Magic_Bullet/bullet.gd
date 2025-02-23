extends Area2D
@export var speed: float = 500
var direction: Vector2

func _ready():
	# Normalize direction to ensure consistent speed
	add_to_group("player_bullet")
	direction = direction.normalized()
func _process(delta):
	position += direction * speed * delta
