extends CharacterBody2D

class_name Entity

var health: float
var attack: float
var projectile_speed: float
var cast_cooldown: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when a body enters the hitbox
func _on_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

# Called when a body exits the hitbox
func _on_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
