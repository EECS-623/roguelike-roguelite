class_name DashDraugrStateStagger extends State

@export var knockback_duration: float = 0.2
var knockback_velocity: Vector2 = Vector2.ZERO
var timer: float
var knockback_direction: Vector2
@onready var dash_draugr = $"../.."
@onready var raycast_component: RaycastComponent = $"../../RaycastComponent"
@onready var chase: DashDraugrStateChase = $"../DashDraugrStateChase"
@onready var idle: DashDraugrStateIdle = $"../DashDraugrStateIdle"
@onready var particles = $"../../Particles"
#@onready var state_machine: DashDraugrStateMachine =  $".."

# what happens when the entity enters a state
func enter() -> void:
	dash_draugr.update_animation("idle")
	var knockback_emission = -(raycast_component.player.global_position - dash_draugr.global_position).normalized()
	particles.global_rotation = knockback_emission.angle()
	particles.restart()
	knockback_direction = -(raycast_component.player.global_position - dash_draugr.global_position).normalized()
	timer = knockback_duration
	knockback_velocity = knockback_direction * 300.0

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
	dash_draugr.velocity = knockback_velocity
	return null
