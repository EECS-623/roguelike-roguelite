class_name DraugrStateChase extends State

@onready var raycast_component = $"../../RaycastComponent"
@onready var draugr = $"../.."
@onready var melee_attack = $"../DraugrStateAttack"
@onready var patrol = $"../DraugrStatePatrol"
@export var speed_component : SpeedComponent

func enter() -> void:
	draugr.update_animation("move")
	raycast_component.raycast_length = 500
	
# what happens when the entity exits a state
func exit() -> void:
	pass
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	
	draugr.direction = (raycast_component.player.global_position - draugr.global_position).normalized()
	draugr.velocity = draugr.direction * speed_component.get_speed()
	
	if draugr.global_position.distance_to(raycast_component.player.global_position) < 50:
		return melee_attack
	if draugr.global_position.distance_to(raycast_component.player.global_position) < raycast_component.raycast_length:
		return patrol
	if draugr.set_direction():
		draugr.update_animation("move")

	return null
	
func state_physics_process(delta: float) -> State:
	return null
