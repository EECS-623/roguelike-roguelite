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
		hit = true
		if body.status_effects["frozen"] == false:
			body.status_effects["frozen"] = true
			
			# might move all the code below to something that the player handles.
			$Sprite2D.visible = false
			set_deferred("hitbox.monitorable", false)
			
			#somehow set the player's speed to lower than it was here
			var current_speed = body.speed_component.get_speed()
			body.speed_component.decrease_speed(150)
			await get_tree().create_timer(2.0).timeout
			
			body.speed_component.set_speed(current_speed)
			body.status_effects["frozen"] = false
			queue_free()
		else:
			queue_free()

static func new_spell(initial_position: Vector2):
	var new_spell: IceVolvaSpell = my_scene.instantiate()
	new_spell.position = initial_position
	return new_spell
