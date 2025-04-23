class_name IceDraugrStateIdle extends State

@onready var ice_draugr : IceDraugr = $"../.."
@onready var patrol : State = $"../IceDraugrStatePatrol"
@onready var melee_attack : State = $"../IceDraugrStateAttack"
@onready var chase : State = $"../IceDraugrStateChase"
@onready var stagger = $"../IceDraugrStateStagger"
@onready var raycast_component : RaycastComponent = $"../../RaycastComponent"
@onready var hurtbox = $"../../Hurtbox"

var cooldown : bool
var staggered: bool = false

# what happens when the entity enters a state
func enter() -> void:
	staggered = false
	hurtbox.connect("hurt", _on_player_melee_hit)
	cooldown = true
	ice_draugr.update_animation("idle")
	await get_tree().create_timer(1).timeout
	cooldown_finished()

# what happens when the entity exits a state
func exit() -> void:
	hurtbox.disconnect("hurt", _on_player_melee_hit)

# what happens during _process of the state
func state_process(delta : float) -> State:
	if staggered:
		return stagger
	
	var player := raycast_component.player
	if !is_instance_valid(player):
		# No player to track, stay idle
		ice_draugr.velocity = Vector2.ZERO
		return null
	
	if !cooldown:
		if ice_draugr.global_position.distance_to(player.global_position) >= raycast_component.raycast_length:
			return patrol
		elif ice_draugr.global_position.distance_to(player.global_position) < 100:
			ice_draugr.direction = (player.global_position - ice_draugr.global_position).normalized()
			ice_draugr.set_direction()
			return melee_attack
		else:
			return chase
			
	ice_draugr.velocity = Vector2.ZERO
	return null

func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null

func cooldown_finished() -> void:
	cooldown = false

func _on_player_melee_hit(body) -> void:
	#this code is so bad lmao
	if body.get_parent().get_parent().is_in_group("player"):
		staggered = true
