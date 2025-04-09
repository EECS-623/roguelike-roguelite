extends Node
class_name PhysicalDamageComponent

@export var physical_damage: float : set = set_physical_damage, get = get_physical_damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_physical_damage(damage: float):
	physical_damage = max(0, damage)
	
func get_physical_damage():
	return physical_damage
	
func increase_physical_damage(num: float):
	physical_damage += num
