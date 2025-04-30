class_name IceVolva extends CharacterBody2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var ice_volva_state_machine : IceVolvaStateMachine = $IceVolvaStateMachine
@onready var speed_component: SpeedComponent = $SpeedComponent

var direction : Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.ZERO
var state = "idle"
var player : CharacterBody2D
signal change_hitbox_direction( new_direction: Vector2 )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemy")
	ice_volva_state_machine.initialize(self)
	$AnimatedSprite2D.modulate = Color(0.65, 0.85, 0.95, 0.9)
	#waggro_range.connect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	#global_position += velocity
	#velocity = direction * speed_component.get_speed()
	move_and_collide(velocity * delta)

func set_direction() -> bool:
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if abs(direction.x) > abs(direction.y):
		new_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		new_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP
		
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
	call_deferred("_handle_death_deferred")

func _handle_death_deferred() -> void:
	var rune_scene = preload("res://Entities/Enemies/Rune/rune.tscn")
	var rune = rune_scene.instantiate()
	#var rune2 = rune_scene.instantiate()
	get_tree().current_scene.add_child(rune)
	#get_tree().current_scene.add_child(rune2)
	rune.drop_from(global_position)
	#rune2.drop_from(global_position)

	#Global.xp += 1
	#Wwise.post_event_id(AK.EVENTS.SKELETON_DEATH, self)
	queue_free()

	
func _on_health_component_t_damage(amount: float) -> void:
	$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color(0.65, 0.85, 0.95, 0.9)
