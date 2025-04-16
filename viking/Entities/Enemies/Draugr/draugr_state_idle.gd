class_name DraugrStateIdle extends State

@onready var draugr : Draugr = $"../.."
@onready var patrol : State = $"../DraugrStatePatrol"
@onready var melee_attack : State = $"../DraugrStateAttack"
@onready var chase : State = $"../DraugrStateChase"
@onready var raycast_component : RaycastComponent = $"../../RaycastComponent"

var cooldown : bool

# what happens when the entity enters a state
func enter() -> void:
	cooldown = true
	draugr.update_animation("idle")
	await get_tree().create_timer(0.5).timeout
	cooldown_finished()

# what happens when the entity exits a state
func exit() -> void:
	pass

# what happens during _process of the state
func state_process(delta : float) -> State:
	if !cooldown:
		if draugr.global_position.distance_to(raycast_component.player.global_position) >= raycast_component.raycast_length:
			return patrol
		elif draugr.global_position.distance_to(raycast_component.player.global_position) < 100:
			draugr.direction = (raycast_component.player.global_position - draugr.global_position).normalized()
			draugr.set_direction()
			return melee_attack
		else:
			return chase
			
	draugr.velocity = Vector2.ZERO
	return null

func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null

func cooldown_finished() -> void:
	cooldown = false
