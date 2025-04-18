class_name StateSpecialAbility extends PlayerState

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : StateIdle = $"../StateIdle"
@onready var move: StateMove = $"../StateMove"
@onready var hitbox: Hitbox = $"../../MeleeHitboxInteractions/Hitbox"
@export var ability: SpecialAbilityComponent

var casting : bool = false

func enter() -> void:
	player.update_animation("idle")
	#connects when animation player ends to "end attack" function
	casting = true
	ability.cast_ability()
	await get_tree().create_timer(0.25).timeout
	end_cast("cast")

# what happens when the entity exits a state
func exit() -> void:
	#remove connection when exiting state
	#animation_player.animation_finished.disconnect( end_cast )
	casting = false

# what happens during _process of the state
func state_process(delta : float) -> State:
	
	player.velocity = Vector2.ZERO
	if !casting:
		if player.direction == Vector2.ZERO:
			print("idle now")
			return idle
		else:
			return move
		
	return null
	
func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	return null

# ends the attack (animation name added to avoid compiler issues)
func end_cast( _animation_name : String) -> void:
	casting = false
