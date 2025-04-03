class_name DraugrStateIdle extends DraugrState

@onready var move : State = $"../DraugrStateMove"
@onready var melee_attack : State = $"../DraugrStateAttack"
@onready var aggro_range : AggroRangeComponent = $"../../AggroRangeComponent"

# what happens when the entity enters a state
func enter() -> void:
	draugr.update_animation("idle")

# what happens when the entity exits a state
func exit() -> void:
	pass

# what happens during _process of the state
func state_process(delta : float) -> State:

	if (aggro_range.in_aggro):
		return move
	
	draugr.velocity = Vector2.ZERO
	return null

func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null
