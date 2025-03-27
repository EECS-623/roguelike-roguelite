## Custom Hitbox node

extends Area2D

class_name Hurtbox

@export var damage: int = 0

signal hurt(body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(hitbox: Hitbox):
	if (hitbox == null):
		return
	else:
		emit_signal("hurt", hitbox)
