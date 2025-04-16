extends Node
class_name HealthComponent

@export var max_health: float : set = set_max_health, get = get_max_health
var current_health: float

signal death
signal t_damage (amount: float)
signal i_max_health (amount : float)
signal i_current_health (amount : float)
var ForceFieldOn = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: float) -> void:
	if ForceFieldOn:
		return
	current_health -= damage
	print(current_health)
	t_damage.emit(current_health)
	if (current_health <= 0):
		handle_death()

func set_max_health(health: float):
	max_health = max(0, health)
	
func get_max_health():
	return max_health
	
func increase_max_health(num: float):
	max_health += num
	i_max_health.emit(max_health)

func increase_current_health(num: float):
	current_health += num
	if (current_health > max_health):
		current_health = max_health
	i_current_health.emit(current_health)

func handle_death():
	# might change this logic later, especially with the player
	death.emit()


func _on_force_field_force_field_on() -> void:
	ForceFieldOn = true


func _on_force_field_force_field_off() -> void:
	ForceFieldOn = false
