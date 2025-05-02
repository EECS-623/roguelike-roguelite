class_name DraugrStateStagger extends State

@export var knockback_duration: float = 0.2
var knockback_velocity: Vector2 = Vector2.ZERO
var timer: float
var knockback_direction: Vector2
@onready var draugr = $"../.."
@onready var raycast_component: RaycastComponent = $"../../RaycastComponent"
@onready var chase: DraugrStateChase = $"../DraugrStateChase"
@onready var idle: DraugrStateIdle = $"../DraugrStateIdle"
@onready var particles = $"../../Particles"
#@onready var state_machine: DraugrStateMachine =  $".."

# what happens when the entity enters a state
func enter() -> void:
	draugr.update_animation("idle")
	var knockback_emission = -(raycast_component.player.global_position - draugr.global_position).normalized()
	particles.global_rotation = knockback_emission.angle()
	particles.restart()
	knockback_direction = -(raycast_component.player.global_position - draugr.global_position).normalized()
	timer = knockback_duration
	knockback_velocity = knockback_direction * 400.0

# what happens when the entity exits a state
func exit() -> void:
	idle.start_cooldown()

# what happens during _process of the state
func state_process(delta : float) -> State:
	timer -= delta
	if timer <= 0:
		return idle
	return null

func state_physics_process(delta: float) -> State:
	draugr.velocity = knockback_velocity
	return null
