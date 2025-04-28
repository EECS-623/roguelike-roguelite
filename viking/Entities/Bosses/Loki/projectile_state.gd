class_name Projectile extends State

@onready var move : State = $"../Move"
@export var s_projectile: PackedScene


var loki
var player

var finished = false


# what happens when the entity enters a state
func enter() -> void:
	finished = false
	var direction_to_player = (player.global_position - loki.global_position).normalized()
	
	loki.update_animation("projectile", direction_to_player)

	await get_tree().create_timer(.5).timeout
	var projectile = s_projectile.instantiate()
	projectile.player = player
	var muzzle = loki.get_node("AnimatedSprite2D/Muzzle")
	projectile.global_position = muzzle.global_position

	get_tree().current_scene.add_child(projectile)
	

	await get_tree().create_timer(1).timeout
	finished = true


# what happens during _process of the state
func state_process(delta : float) -> State:
	if finished:
		return move
	return null
	
func can_move_during():
	return false
