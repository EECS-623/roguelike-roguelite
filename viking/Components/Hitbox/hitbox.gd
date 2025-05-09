## Custom Hitbox node

extends Area2D

class_name Hitbox

@export var is_magic : bool
@export var is_melee : bool
@export var damage: float = 0 : set = set_damage, get = get_damage
@export var physical_damage : PhysicalDamageComponent
@export var magic_damage : MagicDamageComponent

signal hit(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if physical_damage:
		damage = physical_damage.get_physical_damage()
	monitoring = true
	monitorable = true
	
func set_damage(value: float):
	if (is_magic):
		damage = magic_damage.get_magic_damage()
	else:
		damage = value
	
func get_damage() -> float:
	if physical_damage:
		return physical_damage.get_physical_damage()
	return damage

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hit.emit(body)
