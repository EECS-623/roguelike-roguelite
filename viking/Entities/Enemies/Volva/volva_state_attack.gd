class_name VolvaStateAttack extends State

var attacking : bool = false

@onready var volva : Volva = $"../.."
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../VolvaStateIdle"
@onready var raycast_component = $"../../RaycastComponent"

func enter() -> void:
	volva.update_animation("attack")
	
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
	idle.cooldown = true

# what happens during _process of the state
func state_process(delta : float) -> State:
	volva.velocity = Vector2.ZERO

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

func fire_bullet(initial_position: Vector2) -> void:
	var spell_target = (raycast_component.player.global_position - volva.global_position).normalized()
	volva.add_child(VolvaSpell.new_spell(initial_position, spell_target))
