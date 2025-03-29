## Custom Hitbox node
extends Area2D
class_name Hurtbox

@export var health_component: HealthComponent
@export var owner_node: CharacterBody2D

signal hurt(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	if (body == null):
		return
	if body is Hitbox:
		var hitbox = body as Hitbox
		var attacker = body.get_parent()
		
		# player takes damage from the enemies
		# maybe use an if statement later for projectiles?
		if owner_node.is_in_group("player") and attacker.is_in_group("enemy"):
			health_component.take_damage(hitbox.damage)

		# enemies take damage from the player
		elif owner_node.is_in_group("enemy") and attacker.is_in_group("player"):
			health_component.take_damage(hitbox.damage)
