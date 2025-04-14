class_name Build extends State

@onready var idle : State = $"../Idle"

var ice_golem
var player


# what happens when the entity enters a state
func enter() -> void:
	pass
	#ice_golem.update_animation("build")

# what happens when the entity exits a state
func exit() -> void:
	pass

# what happens during _process of the state
func state_process(delta : float) -> State:
	return null

func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null
