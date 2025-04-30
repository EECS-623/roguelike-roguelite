class_name DraugrStateAlert extends State
# makes it so the player can hide back behind a wall after alerting an enemy

@onready var draugr: Draugr = $"../.."
@onready var raycast_component: RaycastComponent = $"../../RaycastComponent"
@onready var chase = $"../DraugrStateChase"
@onready var patrol = $"../DraugrStatePatrol"

var alert = false
var not_alert = false

func enter() -> void:
	alert = false
	not_alert = false 
	draugr.direction = (raycast_component.player.global_position - draugr.global_position).normalized()
	draugr.set_direction()
	draugr.update_animation("idle")
	draugr.velocity = Vector2.ZERO
	await get_tree().create_timer(0.5).timeout
	check_alert()

# what happens when the entity exits a state
func exit() -> void:
	pass
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	if alert:
		return chase
	if not_alert:
		return patrol

	return null
	
func state_physics_process(delta: float) -> State:
	return null

func check_alert() -> void:
	if raycast_component.on_player:
		alert = true
	else:
		not_alert = true
