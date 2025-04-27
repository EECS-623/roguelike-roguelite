class_name IceVolvaStateIdle extends State

@onready var ice_volva : IceVolva = $"../.."
@onready var patrol : State = $"../IceVolvaStatePatrol"
@onready var ranged_attack : State = $"../IceVolvaStateAttack"
@onready var chase : State = $"../IceVolvaStateChase"
@onready var stagger = $"../IceVolvaStateStagger"
@onready var raycast_component : RaycastComponent = $"../../RaycastComponent"
@onready var hurtbox = $"../../Hurtbox"

var cooldown : bool
var staggered: bool = false
var cooldown_timer

# what happens when the entity enters a state
func enter() -> void:
	staggered = false
	hurtbox.connect("hurt", _on_player_melee_hit)

	ice_volva.update_animation("idle")

# what happens when the entity exits a state
func exit() -> void:
	hurtbox.disconnect("hurt", _on_player_melee_hit)

# what happens during _process of the state
func state_process(delta : float) -> State:
	if cooldown:
		cooldown_timer -= delta
		if cooldown_timer <= 0.0:
			cooldown = false
			print("Cooldown finished")
	
	if staggered:
		return stagger
	
	var player := raycast_component.player
	if !is_instance_valid(player):
		# No player to track, stay idle
		ice_volva.velocity = Vector2.ZERO
		return null
	
	if !cooldown:
		if ice_volva.global_position.distance_to(player.global_position) >= raycast_component.raycast_length:
			return patrol
		elif ice_volva.global_position.distance_to(player.global_position) < 400 and raycast_component.on_player:
			ice_volva.direction = (player.global_position - ice_volva.global_position).normalized()
			ice_volva.set_direction()
			return ranged_attack
		else:
			return chase
			
	ice_volva.velocity = Vector2.ZERO
	return null

func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null
	
func start_cooldown(time: float = 2.5) -> void:
	if not cooldown:
		cooldown = true
		cooldown_timer = time

func _on_player_melee_hit(body) -> void:
	var entity = body.get_parent().get_parent()
	#this code is so bad lmao
	if entity.is_in_group("player") and body.is_melee:
		staggered = true
