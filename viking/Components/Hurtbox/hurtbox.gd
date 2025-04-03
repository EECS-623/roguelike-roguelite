## Custom Hurtbox node
extends Area2D
class_name Hurtbox

@export var health_component: HealthComponent
@export var owner_node: CharacterBody2D

signal hurt(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = true
	monitorable = true
	connect("area_entered", Callable(self, "_on_area_entered"))

#player: layer-2 mask-3
#enemy: layer-3 mask-2

func _on_area_entered(hitbox: Node2D):
	if hitbox == null:
		return

	if hitbox is Hitbox:
		var attacker = hitbox.get_parent() 
		if attacker and health_component: 
			health_component.take_damage(hitbox.get_damage())
