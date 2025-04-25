class_name DraugrStateIdle extends State

@onready var draugr : Draugr = $"../.."
@onready var patrol : State = $"../DraugrStatePatrol"
@onready var melee_attack : State = $"../DraugrStateAttack"
@onready var chase : State = $"../DraugrStateChase"
@onready var stagger = $"../DraugrStateStagger"
@onready var raycast_component : RaycastComponent = $"../../RaycastComponent"
@onready var hurtbox = $"../../Hurtbox"

var cooldown : bool
var staggered: bool = false
var cooldown_timer

# what happens when the entity enters a state
func enter() -> void:
	staggered = false
	hurtbox.connect("hurt", _on_player_melee_hit)
	draugr.update_animation("idle")

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
		draugr.velocity = Vector2.ZERO
		return null
	
	if !cooldown:
		if draugr.global_position.distance_to(player.global_position) >= raycast_component.raycast_length:
			return patrol
		elif draugr.global_position.distance_to(player.global_position) < 100:
			draugr.direction = (player.global_position - draugr.global_position).normalized()
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

func start_cooldown(time: float = 1.25) -> void:
	if not cooldown:
		cooldown = true
		cooldown_timer = time

func _on_player_melee_hit(body) -> void:
	#this code is so bad lmao
	if body.get_parent().get_parent().is_in_group("player"):
		staggered = true
