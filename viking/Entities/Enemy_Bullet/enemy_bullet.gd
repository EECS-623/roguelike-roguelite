extends Area2D
@export var speed: float = 500
var direction: Vector2

func _ready():
	# Normalize direction to ensure consistent speed
	add_to_group("enemy_bullet")
	add_to_group("enemy")
	direction = direction.normalized()
func _process(delta):
	position += direction * speed * delta



func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("Player")):
		Global.player_health -= 10
		queue_free()
		print("hit player")
