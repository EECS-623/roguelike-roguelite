extends RigidBody3D

@export var speed: float = 20.0
var direction: Vector3 = Vector3.ZERO

func _ready():
	# Launch it using an impulse in the given direction
	apply_impulse(direction * speed)
	await get_tree().create_timer(5.0).timeout
	queue_free()
