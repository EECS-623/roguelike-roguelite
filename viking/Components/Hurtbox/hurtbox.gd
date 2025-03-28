## Custom Hitbox node
extends Area2D
class_name Hurtbox

@export var health_component: HealthComponent

signal hurt(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	if (body == null):
		return
	if body is Hitbox:
		var hitbox = body as Hitbox
		health_component.take_damage(hitbox.damage)
