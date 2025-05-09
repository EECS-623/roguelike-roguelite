class_name DashDraugrStatePatrol extends State

@onready var patrol_area : PatrolAreaComponent = $"../../PatrolAreaComponent" 
@onready var dash_draugr = $"../.."
@onready var raycast_component = $"../../RaycastComponent"
@onready var alert = $"../DashDraugrStateAlert"
@onready var hurtbox = $"../../Hurtbox"

@export var speed_component: SpeedComponent
var patrol_area_center: Vector2
var wait_time: float = 1.0
var target_point: Vector2
var waiting: bool
var player_collide: bool = false

func enter() -> void:
	raycast_component.raycast_length = 400
	player_collide = false
	patrol_area_center = dash_draugr.global_position
	raycast_component.connect("player_collision", _on_player_collision)
	_choose_new_target()
	dash_draugr.update_animation("move")
	speed_component.set_speed(80)
	
# what happens when the entity exits a state
func exit() -> void:
	raycast_component.disconnect("player_collision", _on_player_collision)
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	#if raycast hits player, then move to alert state
	if player_collide:
		dash_draugr.velocity = Vector2.ZERO
		return alert
	if waiting:
		dash_draugr.velocity = Vector2.ZERO
		return null

	dash_draugr.direction = (target_point-dash_draugr.global_position).normalized()
	
	dash_draugr.velocity = dash_draugr.direction * speed_component.get_speed()

	dash_draugr.set_direction()
	dash_draugr.update_animation("move")
	
	if dash_draugr.global_position.distance_to(target_point) < 10:
		_reached_target()
		
	return null
	
func state_physics_process(delta: float) -> State:
	return null

func _choose_new_target():
	var radius = patrol_area.get_patrol_area_radius()

	var angle = randf_range(0, TAU)
	var distance = randf_range(50, radius)
	var offset = Vector2(cos(angle), sin(angle)) * distance
	
	target_point = patrol_area_center + offset
	
func _reached_target() -> void:
	waiting = true
	dash_draugr.velocity = Vector2.ZERO
	dash_draugr.update_animation("idle")
	wait_time = randf_range(1.0, 1.5)
	await get_tree().create_timer(wait_time).timeout
	_choose_new_target()
	waiting = false

func _on_player_collision() -> void:
	player_collide = true
