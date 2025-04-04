class_name StateSpecialAbility extends PlayerState

var casting : bool = false

@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : StateIdle = $"../StateIdle"
@onready var move: StateMove = $"../StateMove"
@onready var hitbox: Hitbox = $"../../MeleeHitboxInteractions/Hitbox"
@export var ability: SpecialAbilityComponent

func enter() -> void:
	player.update_animation("attack")
	
	#connects when animation player ends to "end attack" function
	animation_player.animation_finished.connect( end_cast )
	casting = true
	ability.cast_ability()

# what happens when the entity exits a state
func exit() -> void:
	
	#remove connection when exiting state
	animation_player.animation_finished.disconnect( end_cast )
	casting = false

# what happens during _process of the state
func state_process(delta : float) -> State:
	
	player.velocity = Vector2.ZERO
	
	if !casting:
		if player.direction == Vector2.ZERO:
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
