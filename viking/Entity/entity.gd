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

func _on_hurtbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
