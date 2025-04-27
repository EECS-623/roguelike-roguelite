class_name IceVolvaStateChase extends State

@onready var raycast_component = $"../../RaycastComponent"
@onready var ice_volva = $"../.."
@onready var ranged_attack = $"../IceVolvaStateAttack"
@onready var patrol = $"../IceVolvaStatePatrol"
@onready var stagger = $"../IceVolvaStateStagger"
@onready var idle = $"../IceVolvaStateIdle"
@onready var hurtbox = $"../../Hurtbox"
@export var speed_component : SpeedComponent

var staggered: bool = false

func enter() -> void:
	staggered = false
	ice_volva.update_animation("move")
	raycast_component.raycast_length = 900
	speed_component.set_speed(130)
	hurtbox.connect("hurt", _on_player_melee_hit)
	
# what happens when the entity exits a state
func exit() -> void:
	hurtbox.disconnect("hurt", _on_player_melee_hit)
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	var player = raycast_component.player 
	
	if staggered:
		return stagger
	
	if ice_volva.global_position.distance_to(player.global_position) < 400 and raycast_component.on_player:
		return ranged_attack

	if ice_volva.global_position.distance_to(player.global_position) >= raycast_component.raycast_length:
		return patrol

	ice_volva.set_direction()
	ice_volva.update_animation("move")

	ice_volva.direction = (raycast_component.player.global_position - ice_volva.global_position).normalized()
	ice_volva.velocity = ice_volva.direction * speed_component.get_speed()

	return null
	
func state_physics_process(delta: float) -> State:
	return null

func _on_player_melee_hit(body) -> void:
	var entity = body.get_parent().get_parent()
	#this code is so bad lmao
	if entity.is_in_group("player") and body.is_melee:
		staggered = true
