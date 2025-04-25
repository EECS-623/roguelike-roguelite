class_name Throw extends State

@onready var idle : State = $"../Idle"
@export var s_snowball: PackedScene


var ice_golem
var player

var finished = false


# what happens when the entity enters a state
func enter() -> void:
	ice_golem.get_node("AnimatedSprite2D").animation = "throw"
	await get_tree().create_timer(.5).timeout


	var snowball = s_snowball.instantiate()
	snowball.player = player
	snowball.global_position = ice_golem.global_position + Vector2(100, 0)

	get_tree().current_scene.add_child(snowball)
	ice_golem.get_node("AnimatedSprite2D").animation = "idle"



	await get_tree().create_timer(1).timeout
	finished = true


# what happens during _process of the state
func state_process(delta : float) -> State:
	if finished:
		return idle
	return null
