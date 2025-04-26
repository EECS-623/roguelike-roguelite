class_name VolvaStateAttack extends State

var attacking : bool = false

@onready var volva : Volva = $"../.."
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var idle : State = $"../VolvaStateIdle"
@onready var raycast_component = $"../../RaycastComponent"
@onready var stagger = $"../VolvaStateStagger"
@onready var hurtbox = $"../../Hurtbox"

var staggered: bool = false
func enter() -> void:
	staggered = false
	volva.update_animation("attack")
	if !hurtbox.is_connected("hurt", _on_player_melee_hit):
		hurtbox.connect("hurt", _on_player_melee_hit)
	#connects when animation player ends to "end attack" function
	if not animation_player.is_connected("animation_finished", end_attack):
		animation_player.animation_finished.connect( end_attack )
	attacking = true



# what happens when the entity exits a state
func exit() -> void:
	hurtbox.disconnect("hurt", _on_player_melee_hit)
	#remove connection when exiting state
	if animation_player.is_connected("animation_finished", end_attack):
		animation_player.animation_finished.disconnect( end_attack )
	attacking = false

	idle.start_cooldown()

# what happens during _process of the state
func state_process(delta : float) -> State:
	volva.velocity = Vector2.ZERO

	if staggered:
		return stagger
	
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
	var spell = VolvaSpell.new_spell(initial_position)
	await get_tree().create_timer(0.4).timeout
	var spell_target = (raycast_component.player.global_position - volva.global_position).normalized()	
	spell.target = spell_target
	volva.add_child(spell)

func _on_player_melee_hit(body) -> void:
	#this code is so bad lmao
	if body.get_parent().get_parent().is_in_group("player"):
		staggered = true
