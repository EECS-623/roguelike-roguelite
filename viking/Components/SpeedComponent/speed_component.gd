extends Node
class_name SpeedComponent

@export var speed: float : set = set_speed, get = get_speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_speed(num: float):
	speed = max(0, num)
	
func get_speed():
	return speed
	
func increase_speed(num: float):
	speed += num
