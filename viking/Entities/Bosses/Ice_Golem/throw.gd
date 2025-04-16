class_name Throw extends State

@onready var idle : State = $"../Idle"
@export var s_snowball: PackedScene


var ice_golem
var player

var finished = false


# what happens when the entity enters a state
func enter() -> void:
	#ice_golem.update_animation("throw")

	var snowball = s_snowball.instantiate()
	snowball.player = player
	snowball.global_position = ice_golem.global_position
	get_tree().current_scene.add_child(snowball)


	await get_tree().create_timer(1).timeout
	finished = true


# what happens during _process of the state
func state_process(delta : float) -> State:
	if finished:
		return idle
	return null
