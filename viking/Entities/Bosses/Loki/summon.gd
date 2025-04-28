class_name Summon extends State

@onready var move : State = $"../Move"
@export var s_draugr: PackedScene
@export var s_volva: PackedScene



var summoned

var loki
var player

var direction_to_player
var radius = 200

var finished = false


# what happens when the entity enters a state
func enter() -> void:
	
	#Loki, Player, Portal, Area2D and 6 summoned enemies (clones, draugrs, witches)
	if len(get_tree().current_scene.get_children()) <= 10:
		finished = false
		direction_to_player = (player.global_position - loki.global_position).normalized()

		var witch = true if randf() > .75 else false

		if witch:
			summon_witch()
		else:
			summon_draugrs()

		await get_tree().create_timer(4).timeout
		
	finished = true



# what happens during _process of the state
func state_process(delta : float) -> State:
	if finished:
		return move
	return null


func summon_witch():
	loki.update_animation("draugr", direction_to_player)
	await get_tree().create_timer(1.1).timeout
	loki.get_node("AnimationPlayer").pause()
	var angle = 2*PI*randf()
	var spawn_offset = Vector2(cos(angle), sin(angle)) * radius
	var spawn_position = player.global_position + spawn_offset

	var volva = s_volva.instantiate()
	volva.player = player
	volva.global_position = spawn_position
	volva.summon = true
	
	get_tree().current_scene.add_child(volva)

func summon_draugrs():
	var angles = [90, 210, 330]
	
	for angle in angles:
		loki.update_animation("draugr", direction_to_player)
		await get_tree().create_timer(1).timeout
		var spawn_offset = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle))) * radius
		var spawn_position = player.global_position + spawn_offset

		var draugr = s_draugr.instantiate()
		draugr.player = player
		draugr.global_position = spawn_position
		draugr.summon = true
		
		get_tree().current_scene.add_child(draugr)

	
func can_move_during():
	return false
