class_name DraugrStateMove extends DraugrState

@export var speed_component : SpeedComponent
@onready var idle : DraugrState = $"../DraugrStateIdle"
@onready var melee_attack : DraugrState = $"../DraugrStateAttack"
@onready var aggro_range : AggroRangeComponent = $"../../AggroRangeComponent"

# what happens when the entity enters a state
func enter() -> void:
	draugr.update_animation("move")
	
# what happens when the entity exits a state
func exit() -> void:
	pass

# what happens during _process of the state
func state_process(delta : float) -> State:
	if !aggro_range.in_aggro:
		return idle
	
	if draugr.global_position.distance_to(aggro_range.player.global_position) < 100:
		return melee_attack
	
	draugr.velocity = draugr.direction * speed_component.get_speed()

	if draugr.set_direction():
		draugr.update_animation("move")
	
	return null

func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null
