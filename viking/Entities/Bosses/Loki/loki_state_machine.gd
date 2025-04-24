class_name LokiStateMachine extends Node

var states : Array[ State ]
var prev_state : State
var current_state : State
var loki : CharacterBody2D
var player : CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_state( current_state.state_process(delta) )
	
func _physics_process(delta: float) -> void:
	change_state( current_state.state_physics_process(delta) )

func _unhandled_input(event: InputEvent) -> void:
	change_state( current_state.handle_input(event) )

func initialize() -> void:
	
	states = []
	for c in get_children():
		if c is State:
			states.append(c)
			c.loki = loki
			c.player = player
			
		change_state( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT


func change_state(new_state: State) -> void:
	if new_state == null or new_state == current_state:
		return

	if current_state:
		current_state.exit()

	prev_state = current_state 
	current_state = new_state
	current_state.enter()

	
