## Custom Hitbox node

extends Area2D

class_name Hurtbox

@export var damage: int = 0

signal hurt(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	if (body == null):
		return
	if body is Hitbox:
		var hitbox = body as Hitbox
		if (owner.has_method("take_damage")):
			owner.take_damage(hitbox.damage)
		
