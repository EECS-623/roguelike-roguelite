class_name IceVolvaStateStagger extends State

@export var knockback_duration: float = 0.2
var knockback_velocity: Vector2 = Vector2.ZERO
var timer: float
var knockback_direction: Vector2
@onready var ice_volva = $"../.."
@onready var raycast_component: RaycastComponent = $"../../RaycastComponent"
@onready var idle: IceVolvaStateIdle = $"../IceVolvaStateIdle"
#@onready var idle: IceVolvaStateIdle = $"../IceVolvaStateIdle"
@onready var particles = $"../../Particles"
#@onready var state_machine: DraugrStateMachine =  $".."

# what happens when the entity enters a state
func enter() -> void:
	ice_volva.update_animation("idle")
	var knockback_emission = -(raycast_component.player.global_position - ice_volva.global_position).normalized()
	particles.global_rotation = knockback_emission.angle()
	particles.restart()
	knockback_direction = -(raycast_component.player.global_position - ice_volva.global_position).normalized()
	timer = knockback_duration
	knockback_velocity = knockback_direction * 550.0


# what happens when the entity exits a state
func exit() -> void:
	# Start cooldown to prevent immediate attack
	idle.start_cooldown()

# what happens during _process of the state
func state_process(delta : float) -> State:
	timer -= delta
	if timer <= 0:
		return idle
	return null

func state_physics_process(delta: float) -> State:
	ice_volva.velocity = knockback_velocity
	return null
