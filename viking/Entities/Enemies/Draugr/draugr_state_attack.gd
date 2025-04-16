class_name DraugrStateAttack extends State

var attacking : bool = false

@onready var draugr : Draugr = $"../.."
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../DraugrStateIdle"
@onready var move: State = $"../DraugrStateMove"
@onready var hitbox: Hitbox = $"../../Interactions/Hitbox"

func enter() -> void:
	draugr.update_animation("attack")
	
	#connects when animation player ends to "end attack" function
	animation_player.animation_finished.connect( end_attack )
	attacking = true
	print("entered attack")

# what happens when the entity exits a state
func exit() -> void:
	#remove connection when exiting state
	animation_player.animation_finished.disconnect( end_attack )
	attacking = false
	hitbox.get_child(0).disabled = true
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	draugr.velocity = Vector2.ZERO
	
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
	attacking = false
