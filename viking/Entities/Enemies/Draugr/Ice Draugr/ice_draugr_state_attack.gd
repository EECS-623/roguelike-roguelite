class_name IceDraugrStateAttack extends State

var attacking : bool = false

@onready var ice_draugr : IceDraugr = $"../.."
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../IceDraugrStateIdle"
@onready var hitbox: Hitbox = $"../../Interactions/Hitbox"

func enter() -> void:
	ice_draugr.update_animation("attack")
	
	#connects when animation player ends to "end attack" function
	animation_player.animation_finished.connect( end_attack )
	attacking = true


# what happens when the entity exits a state
func exit() -> void:
	#remove connection when exiting state
	animation_player.animation_finished.disconnect( end_attack )
	attacking = false
	hitbox.get_child(0).disabled = true
	
# what happens during _process of the state
func state_process(delta : float) -> State:
	ice_draugr.velocity = Vector2.ZERO
	
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

func _on_hitbox_hit(body: Variant) -> void:
	var body_parent = body.get_parent()
	if body_parent.is_in_group("player"):
		if body_parent.status_effects["frozen"] == false:
			body_parent.status_effects["frozen"] = true
			var current_speed = body_parent.speed_component.get_speed()
			body_parent.speed_component.decrease_speed(100)
			await get_tree().create_timer(1.0).timeout
			body_parent.speed_component.set_speed(current_speed)
			body_parent.status_effects["frozen"] = false
