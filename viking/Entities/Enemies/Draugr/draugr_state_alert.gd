class_name DraugrStateAlert extends State



func enter() -> void:
	pass

# what happens when the entity exits a state
func exit() -> void:
	pass
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	return null
	
func state_physics_process(delta: float) -> State:
	return null
