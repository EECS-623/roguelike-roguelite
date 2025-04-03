class_name Draugr extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var draugr_state_machine : DraugrStateMachine = $DraugrStateMachine
@onready var aggro_range: AggroRangeComponent = $AggroRangeComponent

var direction : Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.ZERO
var state = "idle"
var player : CharacterBody2D
signal change_hitbox_direction( new_direction: Vector2 )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")
	draugr_state_machine.initialize(self)
	#waggro_range.connect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if (aggro_range.in_aggro):
		direction = (aggro_range.player.global_position - global_position).normalized()
	else: 
		direction = Vector2.ZERO
	global_position += velocity

func set_direction() -> bool:
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false

	if direction.y == 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
		
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	elif direction.x < 0:
		new_direction = Vector2.LEFT
	
	elif direction.x >0:
		new_direction = Vector2.RIGHT

	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	change_hitbox_direction.emit(cardinal_direction)
	return true

func update_animation( state: String ) -> void:
	animation_player.play( state + "_" + animation_direction())

func animation_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"

func _on_health_component_death() -> void:
	queue_free()
