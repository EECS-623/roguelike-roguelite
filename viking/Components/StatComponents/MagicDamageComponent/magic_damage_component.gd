extends Node
class_name MagicDamageComponent

@export var magic_damage: float : set = set_magic_damage, get = get_magic_damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_magic_damage(damage: float):
	magic_damage = max(0, damage)
	
func get_magic_damage():
	return magic_damage
	
func increase_magic_damage(num: float):
	magic_damage += num
