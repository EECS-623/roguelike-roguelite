class_name DraugrStateChase extends State

@onready var raycast_component = $"../../RaycastComponent"
@onready var draugr = $"../.."
@onready var melee_attack = $"../DraugrStateAttack"
@onready var patrol = $"../DraugrStatePatrol"
@onready var stagger = $"../DraugrStateStagger"
@onready var hurtbox = $"../../Hurtbox"
@export var speed_component : SpeedComponent

var staggered: bool = false

func enter() -> void:
	draugr.update_animation("move")
	raycast_component.raycast_length = 800
	speed_component.set_speed(130)
	hurtbox.connect("hurt", _on_player_melee_hit)
	
# what happens when the entity exits a state
func exit() -> void:
	hurtbox.disconnect("hurt", _on_player_melee_hit)
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	
	if draugr.global_position.distance_to(raycast_component.player.global_position) < 100:
		return melee_attack
	if draugr.global_position.distance_to(raycast_component.player.global_position) >= raycast_component.raycast_length:
		return patrol
	draugr.set_direction()
	draugr.update_animation("move")

	draugr.direction = (raycast_component.player.global_position - draugr.global_position).normalized()
	draugr.velocity = draugr.direction * speed_component.get_speed()

	return null
	
func state_physics_process(delta: float) -> State:
	return null

func _on_player_melee_hit(body) -> void:
	staggered = true
