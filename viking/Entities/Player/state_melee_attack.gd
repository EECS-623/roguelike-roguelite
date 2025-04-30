class_name StateMeleeAttack extends PlayerState

var attacking : bool = false

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : StateIdle = $"../StateIdle"
@onready var move: StateMove = $"../StateMove"
@onready var hitbox: Hitbox = $"../../MeleeHitboxInteractions/Hitbox"
@onready var speed_component: SpeedComponent = $"../../SpeedComponent"
@onready var arrow = preload("res://Entities/Player/Arrow/arrow.tscn")

func enter() -> void:
	player.update_animation("attack")
	
	#connects when animation player ends to "end attack" function
	animation_player.animation_finished.connect( end_attack )
	attacking = true

# what happens when the entity exits a state
func exit() -> void:
	#remove connection when exiting state
	animation_player.animation_finished.disconnect( end_attack )
	hitbox.get_child(0).disabled = true
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	
	if attacking:
		player.velocity = Vector2.ZERO
		#pass
	else:
		player.velocity = player.direction * speed_component.get_speed()
	if !attacking:
		if player.direction == Vector2.ZERO:
			#idle.action_in_progress = false
			return idle
		else:
			#move.action_in_progress = false
			return move
		
	return null
	
func state_physics_process(delta: float) -> State:
	return null

func handle_input(_event : InputEvent) -> State:
	# Only handle input if not attacking (prevent new attacks during animation)
	if attacking:
		return null  # Ignore any input if already attacking
		# Example handling input here (this is a simple place to add logic for other actions)
	if _event.button_index == MOUSE_BUTTON_LEFT:  # Left click example
		return null
		#return handle_attack when MOUSE_BUTTON_RIGHT
	elif _event.button_index == MOUSE_BUTTON_RIGHT:
			#action_in_progress = true
			if !player.arrow_cooldown:
				var new_arrow = arrow.instantiate()
				get_tree().current_scene.add_child(new_arrow)
				new_arrow.position = player.global_position
				new_arrow.direction = (player.get_global_mouse_position() - player.global_position).normalized()
				new_arrow.rotation = (player.get_global_mouse_position() - player.global_position).angle()
				player.start_arrow_cooldown()
	return null

#func handle_attack() -> State:
	# Make sure attacking flag is set to prevent multiple attacks
#	if not attacking:
#		return self  # Stay in this state, allowing attack logic to happen
#	return null

# ends the attack (animation name added to avoid compiler issues)
func end_attack( _animation_name : String) -> void:
	attacking = false
	
