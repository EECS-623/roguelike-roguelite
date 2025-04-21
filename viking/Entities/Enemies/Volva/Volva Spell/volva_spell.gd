class_name VolvaSpell 
extends Area2D

const my_scene: PackedScene = preload("res://Entities/Enemies/Volva/Volva Spell/volva_spell.tscn")

@export var speed: float = 500
var target: Vector2

func _ready():
	# Normalize direction to ensure consistent speed
	add_to_group("enemy_bullet")
	add_to_group("enemy")
	await get_tree().create_timer(1).timeout
	queue_free()

func _process(delta):
	if target != null:
		position += target * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		queue_free()
		print("hit player")

static func new_spell(initial_position: Vector2, target: Vector2):
	var new_spell: VolvaSpell = my_scene.instantiate()
	new_spell.position = initial_position
	new_spell.target = target
	return new_spell
