class_name StateMove extends PlayerState

@export var speed_component : SpeedComponent
@onready var idle : State = $"../StateIdle"
@onready var melee_attack : State = $"../StateMeleeAttack"
@onready var special_ability : State = $"../StateSpecialAbility"
var action_in_progress = false

# what happens when the entity enters a state
func enter() -> void:
	player.update_animation("move")

# what happens when the entity exits a state
func exit() -> void:
	pass

# what happens during _process of the state
func state_process(delta : float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = player.direction * speed_component.get_speed()
	
	if player.set_direction():
		player.update_animation("move")
	
	return null

func state_physics_process(delta: float) -> State:
	return null

# what happens when obtaining an input in this state
func handle_input(_event : InputEvent) -> State:
	if _event is InputEventMouseButton and _event.pressed:
		if _event.button_index == MOUSE_BUTTON_LEFT:
			#action_in_progress = true
			return melee_attack
		elif _event.button_index == MOUSE_BUTTON_RIGHT:
			#action_in_progress = true
			return special_ability
	return null
