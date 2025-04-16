extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
@export var player_bullet: PackedScene = preload("res://Entities/Player/Magic_Bullet/Bullet.tscn")
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine : PlayerStateMachine = $PlayerStateMachine
@onready var speed_component = $SpeedComponent


#@export var SPEED : float = 300.0
#@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.ZERO
var state = "idle"
signal change_hitbox_direction( new_direction: Vector2 )

# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_tree.active = true
	PlayerManager.player = self
	add_to_group("player")
	set_health_label()
	$HealthBar.max_value = $HealthComponent.max_health
	$SpeedComponent.set_speed(200)
	state_machine.initialize(self)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	#if Input.is_action_pressed("map"):
		#for enemy in get_tree().get_nodes_in_group("enemies"):
			#enemy.queue_free()

		#get_tree().change_scene_to_file("res://Map/map.tscn")
	set_health_bar()
	
	#if set_state() == true || set_direction() == true:
		#update_animation()
	#	pass

func _unhandled_input(event):
	#if event is InputEventMouseButton and event.pressed:
		#shoot()
	pass
		
func _physics_process(_delta):
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("")
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	
	#velocity = direction * $SpeedComponent.get_speed()
	#var right = "move_right"
	#var up = "move_up"
	#var down = "move_down"
	#var left = "move_left"
	#if direction.x < 0:
		#velocity = direction * $SpeedComponent.get_speed()
		#_animated_sprite.play(left)
		
	#elif direction.x > 0:
	#	_animated_sprite.flip_h = false
	#	velocity = direction * $SpeedComponent.get_speed()
	#	_animated_sprite.play(right)
		
	#elif direction.y <0:
	#	_animated_sprite.flip_h = false
	#	velocity = direction * $SpeedComponent.get_speed()
	#	_animated_sprite.play(up)
		
	#elif direction.y >0:
	#	_animated_sprite.flip_h = false
	#	velocity = direction * $SpeedComponent.get_speed()
	#	_animated_sprite.play(down)
		
	#else:
	#	velocity = Vector2.ZERO
	#	_animated_sprite.frame = 1
	#	_animated_sprite.stop()
	velocity = direction * speed_component.get_speed()
	move_and_slide()

#func shoot():
	#var bullet = player_bullet.instantiate()
	#get_tree().current_scene.add_child(bullet)
	
	#bullet.position = global_position
	#bullet.direction = (get_global_mouse_position() - global_position).normalized()

func set_health_bar() -> void:
	$HealthBar.value = $HealthComponent.current_health

func set_health_label() -> void:
	$HealthBarLabel.text = "Health: %s" % $HealthComponent.current_health

func _on_health_component_death() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Game/GameOver/game_over.tscn")
	#queue_free()

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
	
#func set_state() -> bool:
#	var new_state : String = "idle" if direction == Vector2.ZERO else "move"
#	if new_state == state:
#		return false
#	state = new_state
#	return true

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

var teleport = true
func _on_teleport_teleport() -> void:
	if teleport:
		position = get_global_mouse_position()
		teleport = false
		await get_tree().wcreate_timer(3).timeout
		teleport = true


func _on_health_component_t_damage(amount: float) -> void:
	if self:
		for i in range(2):
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(.01).timeout
			$AnimatedSprite2D.modulate = Color.WHITE
