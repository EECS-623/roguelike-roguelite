class_name DashDraugrStateChase extends State

@onready var raycast_component = $"../../RaycastComponent"
@onready var dash_draugr = $"../.."
@onready var melee_attack = $"../DashDraugrStateAttack"
@onready var dash_attack = $"../DashDraugrStateDashAttack"
@onready var patrol = $"../DashDraugrStatePatrol"
@onready var stagger = $"../DashDraugrStateStagger"
@onready var hurtbox = $"../../Hurtbox"
@onready var hitbox = $"../../Hitbox"
@onready var nav_agent: NavigationAgent2D = $"../../NavigationAgent2D"
@export var speed_component : SpeedComponent

var staggered: bool = false

var target_position: Vector2

func enter() -> void:
	staggered = false
	dash_draugr.update_animation("move")
	raycast_component.raycast_length = 800
	speed_component.set_speed(130)
	hurtbox.connect("hurt", _on_player_melee_hit)
	#if raycast_component.player:
	#	target_position = raycast_component.player.global_position
	#	nav_agent.target_position = target_position

# what happens when the entity exits a state
func exit() -> void:
	hurtbox.disconnect("hurt", _on_player_melee_hit)
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	
	if staggered:
		return stagger

	if dash_draugr.global_position.distance_to(raycast_component.player.global_position) < 100:
		return melee_attack
	if dash_draugr.global_position.distance_to(raycast_component.player.global_position) < 300:
		return dash_attack
	if dash_draugr.global_position.distance_to(raycast_component.player.global_position) >= raycast_component.raycast_length:
		return patrol
		
	#var player_pos = raycast_component.player.global_position
	#if player_pos.distance_to(nav_agent.target_position) > 16:
	#	nav_agent.target_position = player_pos

	#if not nav_agent.is_navigation_finished():
	#	var next_position = nav_agent.get_next_path_position()
	#	print("Next Path Position: ", next_position)
	#	var direction = (next_position - dash_draugr.global_position).normalized()
	#	dash_draugr.direction = direction
	#	dash_draugr.velocity = direction * speed_component.get_speed()
	#else:
	#	dash_draugr.velocity = Vector2.ZERO
	
	dash_draugr.set_direction()
	dash_draugr.update_animation("move")

	dash_draugr.direction = (raycast_component.player.global_position - dash_draugr.global_position).normalized()
	dash_draugr.velocity = dash_draugr.direction * speed_component.get_speed()

	return null
	
func state_physics_process(delta: float) -> State:
	return null

func _on_player_melee_hit(body) -> void:
	#this code is so bad lmao
	if body.get_parent().get_parent().is_in_group("player"):
		staggered = true
