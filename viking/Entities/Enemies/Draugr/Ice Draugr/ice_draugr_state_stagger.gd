class_name IceDraugrStateStagger extends State

@export var knockback_duration: float = 0.2
var knockback_velocity: Vector2 = Vector2.ZERO
var timer: float
var knockback_direction: Vector2
@onready var ice_draugr = $"../.."
@onready var raycast_component: RaycastComponent = $"../../RaycastComponent"
@onready var chase: IceDraugrStateChase = $"../IceDraugrStateChase"
@onready var particles = $"../../Particles"
#@onready var state_machine: IceDraugrStateMachine =  $".."

# what happens when the entity enters a state
func enter() -> void:
	var knockback_emission = -(raycast_component.player.global_position - ice_draugr.global_position).normalized()
	particles.global_rotation = knockback_emission.angle()
	particles.restart()
	knockback_direction = -(raycast_component.player.global_position - ice_draugr.global_position).normalized()
	timer = knockback_duration
	knockback_velocity = knockback_direction * 300.0

# what happens when the entity exits a state
func exit() -> void:
	pass

# what happens during _process of the state
func state_process(delta : float) -> State:
	timer -= delta
	if timer <= 0:
		return chase
	return null

func state_physics_process(delta: float) -> State:
	ice_draugr.velocity = knockback_velocity
	return null
