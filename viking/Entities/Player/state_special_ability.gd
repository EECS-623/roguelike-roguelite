class_name StateSpecialAbility extends PlayerState

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : StateIdle = $"../StateIdle"
@onready var move: StateMove = $"../StateMove"
@onready var hitbox: Hitbox = $"../../MeleeHitboxInteractions/Hitbox"
@export var ability: SpecialAbilityComponent
@onready var speed_component : SpeedComponent = $"../../SpeedComponent"
@onready var arrow = preload("res://Entities/Player/Arrow/arrow.tscn")

var casting : bool = false
func enter() -> void:
	#I Know this looks daunting, but it one of the few ways all the components can work with the polymorphism given the async.
	if Global.patron_god == 1:
		ability = get_node("../../SpecialAbility/CastFireball")
	elif Global.patron_god == 2:
		ability = get_node("../../SpecialAbility/ForceField")
	elif Global.patron_god == 3:
		ability = get_node("../../SpecialAbility/Teleport")
	
	casting = true
			
	if await ability.cast_ability():
		# Ability cast successful
		await get_tree().create_timer(0.25).timeout
		end_cast("cast")
	else:
			# Not enough mana
		var mana_comp = player.get_node("ManaComponent")
		if mana_comp:
			mana_comp.flash_mana_bar_red()
		casting = false
			
	print(ability)
	player.update_animation("idle")
	#connects when animation player ends to "end attack" function
	#casting = true
	#if await ability.cast_ability():
		# Ability cast successful
	#	await get_tree().create_timer(0.25).timeout
	#	end_cast("cast")
	#else:
		# Not enough mana
	#	var mana_comp = player.get_node("ManaComponent")
		#if mana_comp:
			#mana_comp.flash_mana_bar_red() # commented out to fix lightning and shield flash glitch
	#	casting = false

# what happens when the entity exits a state
func exit() -> void:
	#remove connection when exiting state
	#animation_player.animation_finished.disconnect( end_cast )
	casting = false

# what happens during _process of the state
func state_process(delta : float) -> State:
	
	if casting:
		player.velocity = Vector2.ZERO
	else:
		player.velocity = player.direction * speed_component.get_speed()
	player.set_direction()
	if !casting:
		if player.direction == Vector2.ZERO:
			#idle.action_in_progress = false
			print("idle now")
			return idle
		else:
			#move.action_in_progress = false
			return move
		
	return null
	
func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	# not sure if we should have this here, because lightning overlaps with arrow
	if _event is InputEventMouseButton and _event.pressed:
		if _event.button_index == MOUSE_BUTTON_RIGHT:
			#action_in_progress = true
			if !player.arrow_cooldown:
				var new_arrow = arrow.instantiate()
				get_tree().current_scene.add_child(new_arrow)
				new_arrow.position = player.global_position
				new_arrow.direction = (player.get_global_mouse_position() - player.global_position).normalized()
				new_arrow.rotation = (player.get_global_mouse_position() - player.global_position).angle()
				player.start_arrow_cooldown()
	return null

# ends the attack (animation name added to avoid compiler issues)
func end_cast( _animation_name : String) -> void:
	casting = false
