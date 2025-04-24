extends Node
class_name SpeedComponent

@export var max_speed: float: set = set_max_speed, get = get_max_speed
@export var speed: float : set = set_speed, get = get_speed

var speed_multiplier: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#speed = max_speed
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_speed(num: float):
	speed = max(0, num)
	
func get_speed():
	return speed

func set_max_speed(num: float):
	max_speed = max(0, num)
	
func get_max_speed():
	return max_speed

func increase_speed(num: float):
	speed += num

func decrease_speed(num: float):
	speed -= num

func _on_canvas_layer_increase_speed() -> void:
	print("speed before: ")
	print(speed)
	speed += 20
	print("speed after: ")
	print(speed)
