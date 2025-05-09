class_name Idle extends State

var player : CharacterBody2D
var ice_golem : CharacterBody2D

var idle_timer

var move_timer
var move_dir = Vector2(1,0)
var tween: Tween

var dist_thresh = 250

var distance_weights = {
	"Throw" : .5,
	"Build" : .5,
	"Smash" : 0
}

var near_weights = {
	"Throw" : .15,
	"Build" : .15,
	"Smash" : .2
}


# what happens when the entity enters a state
func enter() -> void:
	idle_timer = randf_range(1.5, 3.5)
	move_timer = randf_range(.5, 2)

# what happens when the entity exits a state
func exit() -> void:
	pass

# what happens during _process of the state
func state_process(delta: float) -> State:
	idle_timer -= delta
	if idle_timer <= 0:
		return choose_attack()
	move_timer -= delta
	if move_timer <= 0:
		move_timer = randf_range(.5, 2)
		move()
	return null


func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null

func choose_attack() -> State:
	var distance_to_player = ice_golem.global_position.distance_to(player.global_position)
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
	
	return get_state_by_name("Smash")



func get_state_by_name(name: String) -> State:
	for state in get_parent().states:
		if state.name == name:
			return state
	return null
	
func move():
	if tween and tween.is_running():
		return  # prevent sliding again mid-tween

	var start_pos = ice_golem.global_position
	var end_pos = start_pos + move_dir * 50

	tween = create_tween()
	tween.tween_property(ice_golem, "global_position", end_pos, .5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	move_dir = Vector2(-1, 0) if move_dir == Vector2(1, 0) else Vector2(1, 0)
	
