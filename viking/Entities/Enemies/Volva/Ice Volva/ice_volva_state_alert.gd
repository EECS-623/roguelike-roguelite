class_name IceVolvaStateAlert extends State
# makes it so the player can hide back behind a wall after alerting an enemy

@onready var ice_volva: IceVolva = $"../.."
@onready var raycast_component: RaycastComponent = $"../../RaycastComponent"
@onready var chase = $"../IceVolvaStateChase"
@onready var patrol = $"../IceVolvaStatePatrol"

var alert = false
var not_alert = false

func enter() -> void:
	alert = false
	not_alert = false 
	ice_volva.direction = (raycast_component.player.global_position - ice_volva.global_position).normalized()
	ice_volva.set_direction()
	ice_volva.update_animation("idle")
	ice_volva.velocity = Vector2.ZERO
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
