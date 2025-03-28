extends Node
class_name LuckComponent

@export var luck: float : set = set_luck, get = get_luck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_luck(num: float):
	luck = max(0, num)
	
func get_luck():
	return luck
	
func increase_luck(num: float):
	luck += num
