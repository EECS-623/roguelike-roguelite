extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var state_machine : PlayerStateMachine = $PlayerStateMachine
@onready var speed_component = $SpeedComponent
@onready var interaction_range = $InteractionRange
@onready var status_manager = $StatusEffectManager

var npc: CharacterBody2D

#@export var SPEED : float = 300.0
#@onready var animation_tree = $AnimationTree
var direction : Vector2 = Vector2.ZERO
var cardinal_direction: Vector2 = Vector2.ZERO
var state = "idle"
signal change_hitbox_direction( new_direction: Vector2 )

var slowed_timer = 0
var slowed_perc = 0
var knockback_timer = 0
var knockback_velocity = Vector2(0,0)

var status_effects = {
	"frozen": false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_tree.active = true
	PlayerManager.player = self
	add_to_group("player")
	#$HealthBar.max_value = $HealthComponent.max_health
	$SpeedComponent.set_speed(300)
	state_machine.initialize(self)
		# Ensure the health component is emitting signals correctly
	if has_node("HealthComponent"):
		var health = get_node("HealthComponent")
		print("Player health component initialized: ", health.current_health, "/", health.max_health)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if npc != null:
			npc.talk()
	
	#if set_state() == true || set_direction() == true:
		#update_animation()
		#pass

func _unhandled_input(event):
	#if event is InputEventMouseButton and event.pressed:
		#shoot()
	pass
		
func _physics_process(_delta):
	if knockback_timer > 0.0:
		velocity = knockback_velocity
		knockback_timer -= _delta
	elif slowed_timer > 0:
		direction = Input.get_vector("left", "right", "up", "down").normalized()
		velocity = direction * speed_component.get_speed() * slowed_perc
		slowed_timer -= _delta
	else:
		direction = Input.get_vector("left", "right", "up", "down").normalized()
		velocity = direction * speed_component.get_speed()
	move_and_slide()

#func shoot():
	#var bullet = player_bullet.instantiate()
	#get_tree().current_scene.add_child(bullet)
	
	#bullet.position = global_position
	#bullet.direction = (get_global_mouse_position() - global_position).normalized()

#func set_health_bar() -> void:
	#$HealthBar.value = $HealthComponent.current_health
#
#func set_health_label() -> void:
	#$HealthBarLabel.text = "Health: %s" % $HealthComponent.current_health

func _on_health_component_death() -> void:
	
	#get_tree().root.add_child(self)
	#get_parent().remove_child(self)
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

func _on_health_component_t_damage(amount: float) -> void:
	if self and $HealthComponent.current_health > 0:
		for i in range(2):
			$AnimatedSprite2D.modulate = Color.RED
			await get_tree().create_timer(.01).timeout
			$AnimatedSprite2D.modulate = Color.WHITE


func _on_interaction_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("npc"):
		npc = body

func _on_interaction_range_body_exited(body: Node2D) -> void:
	npc = null

func apply_status_effect(effect: StatusEffect):
	status_manager.apply_status_effect(effect)
