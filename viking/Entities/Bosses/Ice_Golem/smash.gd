class_name Smash extends State

@onready var idle : State = $"../Idle"
@export var s_warning : PackedScene

var ice_golem
var player
var finished = false
var tween: Tween


# what happens when the entity enters a state
func enter() -> void:
	#ice_golem.update_animation("smash")
	var stomp = s_warning.instantiate()
	stomp.global_position = Vector2(0, -385)
	get_tree().current_scene.add_child(stomp)
	stomp.get_node("AnimationPlayer").play("stomp_incoming")
	await get_tree().create_timer(2).timeout
	stomp.visible = false
	player.get_node("Camera2D").start_screen_shake(0.15, 5)

	for icicle in get_tree().get_nodes_in_group("icicles"):
		icicle.shatter()

	var dist = player.global_position.distance_to(Vector2(0, -385))
	var strength = lerp(1000, 300, dist / 500)
	var dir = (player.global_position - Vector2(0, -385)).normalized()
	player.knockback_velocity = dir * strength
	player.knockback_timer = 0.5 

	remove_child(stomp)
	finished = true
	

# what happens during _process of the state
func state_physics_process(delta : float) -> State:
	if finished:
		finished = false
		return idle
	
	return null


# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null
