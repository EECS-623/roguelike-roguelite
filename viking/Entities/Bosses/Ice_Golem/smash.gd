class_name Smash extends State

@onready var idle : State = $"../Idle"
@export var s_warning : PackedScene

var ice_golem
var player
var finished = false
var stomp



func enter() -> void:
	
	stomp = s_warning.instantiate()
	stomp.global_position = Vector2(0, -385)
	get_tree().current_scene.add_child(stomp)
	ice_golem.get_node("AnimationPlayer").play("stomp")
	stomp.get_node("AnimationPlayer").play("stomp_incoming")
	await get_tree().create_timer(2).timeout
	stomp.visible = false
	Wwise.post_event_id(AK.EVENTS.PLAYER_HIT, self)
	player.get_node("Camera2D").start_screen_shake(0.15, 5)

	for icicle in get_tree().get_nodes_in_group("icicles"):
		icicle.shatter()

	var dist = player.global_position.distance_to(Vector2(0, -385))
	var strength = lerp(1000, 300, dist / 500)
	var dir = (player.global_position - Vector2(0, -385)).normalized()
	player.knockback_velocity = dir * strength
	player.knockback_timer = 0.5 
	finished = true
	

# what happens during _process of the state
func state_physics_process(delta : float) -> State:
	if finished:
		finished = false
		return idle
	
	return null


func _on_health_component_death() -> void:
	if stomp != null:
		stomp.get_node("AnimationPlayer").play("RESET")
		stomp.visible = false
		
