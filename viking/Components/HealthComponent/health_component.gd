extends Node
class_name HealthComponent

@export var max_health: float : set = set_max_health, get = get_max_health
var current_health: float
signal death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: float) -> void:
	current_health -= damage
	if (current_health <= 0):
		handle_death()

func set_max_health(health: float):
	max_health = max(0, health)
	
func get_max_health():
	return max_health
	
func increase_max_health(num: float):
	max_health += num

func increase_current_health(num: float):
	current_health += num
	if (current_health > max_health):
		current_health = max_health

func handle_death():
	# might change this logic later, especially with the player
	death.emit()
