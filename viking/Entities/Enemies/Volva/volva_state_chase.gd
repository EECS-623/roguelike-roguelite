class_name VolvaStateChase extends State

@onready var raycast_component = $"../../RaycastComponent"
@onready var volva = $"../.."
@onready var ranged_attack = $"../VolvaStateAttack"
@onready var patrol = $"../VolvaStatePatrol"
@onready var stagger = $"../VolvarStateStagger"
@onready var hurtbox = $"../../Hurtbox"
@export var speed_component : SpeedComponent

var staggered: bool = false

func enter() -> void:
	staggered = false
	volva.update_animation("move")
	raycast_component.raycast_length = 800
	speed_component.set_speed(130)
	hurtbox.connect("hurt", _on_player_melee_hit)
	
# what happens when the entity exits a state
func exit() -> void:
	hurtbox.disconnect("hurt", _on_player_melee_hit)
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	
	if staggered:
		return stagger
	if volva.global_position.distance_to(raycast_component.player.global_position) < 100:
		return ranged_attack
	if volva.global_position.distance_to(raycast_component.player.global_position) >= raycast_component.raycast_length:
		return patrol
	volva.set_direction()
	volva.update_animation("move")

	volva.direction = (raycast_component.player.global_position - volva.global_position).normalized()
	volva.velocity = volva.direction * speed_component.get_speed()

	return null
	
func state_physics_process(delta: float) -> State:
	return null

func _on_player_melee_hit(body) -> void:
	#this code is so bad lmao
	if body.get_parent().get_parent().is_in_group("player"):
		staggered = true
