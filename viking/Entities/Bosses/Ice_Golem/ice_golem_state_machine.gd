class_name IceGolemStateMachine extends Node

var states : Array[ State ]
var prev_state : State
var current_state : State
var ice_golem : CharacterBody2D
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state( current_state.state_process(delta) )
	
func _physics_process(delta: float) -> void:
	change_state( current_state.state_physics_process(delta) )

func _unhandled_input(event: InputEvent) -> void:
	change_state( current_state.handle_input(event) )

func initialize(_ice_golem : CharacterBody2D, _player : CharacterBody2D) -> void:
	ice_golem = _ice_golem
	player = _player
	
	states = []
	for c in get_children():
		if c is State:
			states.append(c)
			
	if states.size() > 0:
		states[0].ice_golem = _ice_golem
		change_state( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT



func change_state(new_state: State) -> void:
	if new_state == null or new_state == current_state:
		return

	if current_state:
		current_state.exit()

	prev_state = current_state 
	current_state = new_state
	current_state.ice_golem = ice_golem
	current_state.player = player
	current_state.enter()
