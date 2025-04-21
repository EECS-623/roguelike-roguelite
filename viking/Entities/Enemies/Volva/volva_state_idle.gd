class_name VolvaStateIdle extends State

@onready var volva : Volva = $"../.."
@onready var patrol : State = $"../VolvaStatePatrol"
@onready var ranged_attack : State = $"../VolvaStateAttack"
@onready var chase : State = $"../VolvaStateChase"
@onready var stagger = $"../VolvaStateStagger"
@onready var raycast_component : RaycastComponent = $"../../RaycastComponent"
@onready var hurtbox = $"../../Hurtbox"

var cooldown : bool
var staggered: bool = false

# what happens when the entity enters a state
func enter() -> void:
	staggered = false
	hurtbox.connect("hurt", _on_player_melee_hit)
	cooldown = true
	volva.update_animation("idle")
	await get_tree().create_timer(2.5).timeout
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
		volva.velocity = Vector2.ZERO
		return null
	
	if !cooldown:
		if volva.global_position.distance_to(player.global_position) >= raycast_component.raycast_length:
			return patrol
		elif volva.global_position.distance_to(player.global_position) < 400 and raycast_component.on_player:
			volva.direction = (player.global_position - volva.global_position).normalized()
			volva.set_direction()
			return ranged_attack
		else:
			return chase
			
	volva.velocity = Vector2.ZERO
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
