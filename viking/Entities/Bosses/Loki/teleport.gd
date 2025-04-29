class_name Teleport extends State

@onready var move : State = $"../Move"

@export var s_projectile: PackedScene

var finished
var loki
var player

var anim_player

func enter() -> void:
	finished = false
	anim_player = loki.get_node("AnimationPlayer")
	for i in randi_range(3,5):
		teleport()
		await get_tree().create_timer(3).timeout


	finished = true


func state_process(delta : float) -> State:
	if finished:
		return move
	return null


func is_position_blocked(pos: Vector2) -> bool:
	var space_state = player.get_world_2d().get_direct_space_state()
	var point = PhysicsPointQueryParameters2D.new()
	point.position = pos
	var result = space_state.intersect_point(point)

	for collision in result:
		if collision.collider is StaticBody2D:
			return true
	
	return false

func can_move_during():
	return false
	
func shoot_projectile():
	await get_tree().create_timer(0.0).timeout 
	var direction_to_player = (player.global_position - loki.global_position).normalized()
	
	loki.update_animation("projectile", direction_to_player)

	await get_tree().create_timer(.5).timeout
	var projectile = s_projectile.instantiate()
	projectile.player = player
	var muzzle = loki.get_node("AnimatedSprite2D/Muzzle")
	projectile.global_position = muzzle.global_position

	get_tree().current_scene.add_child(projectile)

	await get_tree().create_timer(1).timeout
	
func teleport():
	await get_tree().create_timer(0.0).timeout
	var rand_pos
	var found = false
	
	for i in range(10):
		var rand_x = randf_range(-700, 700)
		var rand_y = randf_range(-160, 500)
		rand_pos = Vector2(rand_x, rand_y)
		
		if not is_position_blocked(rand_pos):
			if rand_pos.distance_to(player.global_position) > 300:
				found = true
				break 
	
	if found:
		anim_player.play("teleport")
		await anim_player.animation_finished
		loki.global_position = rand_pos
		
		anim_player.speed_scale = -1.0
		anim_player.play("teleport")
		await get_tree().create_timer(.5).timeout
		
		anim_player.speed_scale = 1.0
		shoot_projectile()
