class_name IceVolvaStateAttack extends State

var attacking : bool = false

@onready var ice_volva : IceVolva = $"../.."
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../IceVolvaStateIdle"
@onready var raycast_component = $"../../RaycastComponent"

func enter() -> void:
	ice_volva.update_animation("attack")
	
	#connects when animation player ends to "end attack" function
	if not animation_player.is_connected("animation_finished", end_attack):
		animation_player.animation_finished.connect( end_attack )
	attacking = true



# what happens when the entity exits a state
func exit() -> void:
	#remove connection when exiting state
	if animation_player.is_connected("animation_finished", end_attack):
		animation_player.animation_finished.disconnect( end_attack )
	attacking = false

	# Start cooldown to prevent immediate attack
	idle.start_cooldown()

# what happens during _process of the state
func state_process(delta : float) -> State:
	ice_volva.velocity = Vector2.ZERO

	if !attacking:
		return idle

	return null
	
func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null

# ends the attack (animation name added to avoid compiler issues)
func end_attack( _animation_name : String) -> void:
	if attacking:
		attacking = false

func spawn_bullet():
	pass

func fire_bullet(initial_position: Vector2) -> void:
	var spell = IceVolvaSpell.new_spell(initial_position)
	await get_tree().create_timer(0.4).timeout
	var spell_target = (raycast_component.player.global_position - ice_volva.global_position).normalized()	
	spell.target = spell_target
	ice_volva.add_child(spell)
