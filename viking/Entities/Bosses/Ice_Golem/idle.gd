class_name Idle extends State

var player
var ice_golem

var idle_timer

var dist_thresh = 200

var distance_weights = {
	"Throw" : .5,
	"Build" : .5,
	"Smash" : 0
}

var near_weights = {
	"Throw" : .3,
	"Build" : .2,
	"Smash" : .5
}


# what happens when the entity enters a state
func enter() -> void:
	ice_golem.update_animation("idle")
	var idle_timer = randf_range(1.5, 3.0)


# what happens when the entity exits a state
func exit() -> void:
	pass

# what happens during _process of the state
func state_process(delta: float) -> State:
	idle_timer -= delta
	if idle_timer <= 0:
		return choose_attack()
	return null


func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null

func choose_attack() -> State:
	var distance_to_player = ice_golem.global_position - player.global_position
	var weights = near_weights if distance_to_player < dist_thresh else distance_weights
	
	var total_weight := 0.0
	for weight in weights.values():
		total_weight += weight
	
	var rand_val := randf() * total_weight
	var cumulative := 0.0
	
	for key in weights.keys():
		cumulative += weights[key]
		if rand_val < cumulative:
			return get_state_by_name(key)
	
	return get_state_by_name("Throw")


func get_state_by_name(name: String) -> State:
	for state in get_parent().states:
		if state.name == name:
			return state
	return null
