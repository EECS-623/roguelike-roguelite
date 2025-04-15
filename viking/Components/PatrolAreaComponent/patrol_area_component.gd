class_name PatrolAreaComponent extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_patrol_area_radius() -> float:
	var shape = $CollisionShape2D.shape
	if shape is CircleShape2D:
		return shape.radius # because extents are half-size
	return 0.0
