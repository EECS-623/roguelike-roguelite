class_name DraugrStatePatrol extends State

@onready var patrol_area : PatrolAreaComponent = $"../../PatrolAreaComponent" 
@onready var draugr = $"../.."
@export var speed_component: SpeedComponent
var patrol_area_center: Vector2
var wait_time: float = 1.0
var target_point: Vector2
var waiting: bool

func enter() -> void:
	patrol_area_center = draugr.global_position
	_choose_new_target()
	draugr.update_animation("move")
	
# what happens when the entity exits a state
func exit() -> void:
	pass
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	#if raycast hits player, then move to alert state
	if waiting:
		draugr.velocity = Vector2.ZERO
		return null
	
	draugr.direction = (target_point-draugr.global_position).normalized()
	
	draugr.velocity = draugr.direction * speed_component.get_speed()

	draugr.set_direction()
	draugr.update_animation("move")
	
	if draugr.global_position.distance_to(target_point) < 10:
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
	draugr.velocity = Vector2.ZERO
	draugr.update_animation("idle")
	wait_time = randf_range(1.0, 1.5)
	await get_tree().create_timer(wait_time).timeout
	_choose_new_target()
	waiting = false
