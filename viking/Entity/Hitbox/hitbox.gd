## Custom Hitbox node

extends Area2D

class_name Hitbox

@export var damage: float = 0 : set = set_damage, get = get_damage

signal hit(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func set_damage(value: float):
	damage = value
	
func get_damage() -> float:
	return damage
