class_name State extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# what happens when the entity enters a state
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

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null
