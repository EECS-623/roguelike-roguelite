class_name IceVolvaSpell 
extends Area2D

const my_scene: PackedScene = preload("res://Entities/Enemies/Volva/Ice Volva Spell/ice_volva_spell.tscn")
@onready var hitbox = $Hitbox
var shooting: bool = false

@export var speed: float = 500
var target: Vector2
var hit: bool = false

func _ready():
	# Normalize direction to ensure consistent speed
	add_to_group("enemy_bullet")
	add_to_group("enemy")
	hitbox.monitorable = false
	await get_tree().create_timer(0.4).timeout
	hitbox.monitorable = true
	shooting = true
	await get_tree().create_timer(1).timeout
	if !hit:
		queue_free()

func _process(delta):
	if target != null and shooting:
		position += target * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")):
		
		var freeze_effect = preload("res://Components/StatusEffects/freeze_effect.gd").new().configure(0.5, 1.5)
		body.apply_status_effect(freeze_effect)
		queue_free()
	else:
		queue_free()

static func new_spell(initial_position: Vector2):
	var new_spell: IceVolvaSpell = my_scene.instantiate()
	new_spell.position = initial_position
	return new_spell
