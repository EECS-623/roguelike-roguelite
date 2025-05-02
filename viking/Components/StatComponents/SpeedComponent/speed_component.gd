extends Node
class_name SpeedComponent

@export var max_speed: float: set = set_max_speed, get = get_max_speed
@export var speed: float : set = set_speed, get = get_speed

var speed_multiplier: float = 1.0 : set = set_multiplier, get = get_multiplier

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#speed = max_speed
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_speed(num: float):
	speed = maxf(0, num)
	
func get_speed():
	return speed * speed_multiplier

func set_max_speed(num: float):
	max_speed = maxf(0, num)
	
func get_max_speed():
	return max_speed

func increase_speed(num: float):
	speed += num

func decrease_speed(num: float):
	speed -= num
	
func set_multiplier(num: float):
	speed_multiplier = minf(1.0, num)

func get_multiplier():
	return speed_multiplier

func _on_canvas_layer_increase_speed() -> void:
	print("speed before: ")
	print(speed)
	speed += 40
	print("speed after: ")
	print(speed)
