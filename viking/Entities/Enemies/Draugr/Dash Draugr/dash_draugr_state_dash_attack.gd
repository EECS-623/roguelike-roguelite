class_name DashDraugrStateDashAttack extends State

@onready var dash_draugr : DashDraugr = $"../.."
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../DashDraugrStateIdle"
@onready var hitbox: Hitbox = $"../../Hitbox"
@onready var raycast_component: RaycastComponent = $"../../RaycastComponent"
@onready var stagger = $"../DashDraugrStateStagger"

var attacking : bool = false
var begin_attack: bool = false
var distance: float = 100.0
var direction: Vector2
var max_dash_distance = 300
var staggered: bool = false

func enter() -> void:
	staggered = false
	begin_attack = false
	if raycast_component.player:
		var dir = (raycast_component.player.global_position - dash_draugr.global_position).normalized()
		dash_draugr.direction = dir
		dash_draugr.set_direction()
	
	dash_draugr.update_animation("dash_attack")
	#connects when animation player ends to "end attack" function
	animation_player.animation_finished.connect( end_attack )
	attacking = true

# what happens when the entity exits a state
func exit() -> void:
	#remove connection when exiting state
	animation_player.animation_finished.disconnect( end_attack )
	attacking = false
	hitbox.get_child(0).disabled = true
	
	idle.start_cooldown()
	
# what happens during _process of the state
func state_process(delta : float) -> State:

	if staggered:
		return stagger

	if begin_attack:
		dash_draugr.velocity = direction * (distance / 0.4)
	else:
		dash_draugr.velocity = Vector2.ZERO
	
	if !attacking:
		dash_draugr.velocity = Vector2.ZERO
		return idle

	return null
	
func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null

# ends the attack (animation name added to avoid compiler issues)
func end_attack( _animation_name : String) -> void:
	attacking = false

func rotate_hitbox() -> void:
	if raycast_component.player:
		var player = raycast_component.player
		var direction = (player.global_position - dash_draugr.global_position).normalized()
		hitbox.rotation = direction.angle()

func dash_attack() -> void:
	var player = raycast_component.player
	direction = (player.global_position - dash_draugr.global_position).normalized()
	distance = clamp(player.global_position.distance_to(dash_draugr.global_position) - 100, 0, max_dash_distance)
	begin_attack = true
	#if begin_attack:
	#	var player = raycast_component.player
	#	var direction = (player.global_position - dash_draugr.global_position).normalized()
	#	distance = player.global_position.distance_to(dash_draugr.global_position) - 150
	#	dash_draugr.velocity = direction * (distance / 0.4)

func _on_player_melee_hit(body) -> void:
	var entity = body.get_parent().get_parent()
	#this code is so bad lmao
	if entity.is_in_group("player") and body.is_melee:
		staggered = true
