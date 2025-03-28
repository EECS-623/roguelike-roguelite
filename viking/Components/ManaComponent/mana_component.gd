extends Node
class_name ManaComponent

@export var max_mana: float : set = set_max_mana, get = get_max_mana
var current_mana: float : get = get_current_mana
var mana_regeneration_rate: float : set = set_mana_regeneration_rate, get = get_mana_regeneration_rate
var timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_mana = max_mana

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# maybe regenerate mana here? 
	timer += delta
	if (timer >= mana_regeneration_rate):
		increase_current_mana(10)
		timer = 0.0

func set_max_mana(mana: float):
	max_mana = max(0, mana)
	
func get_max_mana():
	return max_mana

func get_current_mana():
	return current_mana

func set_mana_regeneration_rate(num: float):
	mana_regeneration_rate = num

func get_mana_regeneration_rate():
	return mana_regeneration_rate

func increase_max_mana(num: float):
	max_mana += num

func increase_current_mana(num: float):
	current_mana += num
	if(current_mana > max_mana):
		current_mana = max_mana
