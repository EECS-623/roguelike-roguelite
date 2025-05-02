class_name MakeSpikes extends State

@onready var move : State = $"../Move"

@export var s_spike: PackedScene

var finished
var loki
var player


func enter() -> void:
	finished = false
	loki.update_animation("spikes")
	
	if loki.global_position.distance_to(player.global_position) > 200:
		var pattern = randi_range(0, 3)
		if pattern == 0:
			spawn_snowflake_pattern()
		elif pattern == 1:
			spawn_line_to_player()
		elif pattern == 2:
			spawn_closing_circle()
		elif pattern == 3:
			spawn_opening_circle()

	await get_tree().create_timer(3).timeout
	
	finished = true


func state_process(delta : float) -> State:
	if finished:
		return move
	return null


func spawn_spike(position: Vector2):
	if not is_position_blocked(position):
		var spike = s_spike.instantiate()
		spike.global_position = position
		spike.add_to_group("spikes")
		add_child(spike)

func is_position_blocked(pos: Vector2) -> bool:
	for child in get_children():
		if child is Icicle and child.global_position.distance_to(pos) < 45:
			child.shatter()
			return false
	
	var space_state = player.get_world_2d().get_direct_space_state()
	var point = PhysicsPointQueryParameters2D.new()
	point.position = pos
	var result = space_state.intersect_point(point)

	for collision in result:
		if collision.collider is StaticBody2D:
			return true
	
	return false


func spawn_snowflake_pattern(spokes := 6, steps := 4, spacing := 50):
	Wwise.post_event_id(AK.EVENTS.ICICLE_APPEAR, self)
	var player_position = player.global_position
	spawn_spike(player_position)
	for i in range(spokes):
		var dir = Vector2.RIGHT.rotated(TAU * i / spokes)
		for j in range(1, steps+1):
			var offset = dir * spacing * j
			var pos = player_position + offset
			spawn_spike(pos)
		await get_tree().create_timer(.2).timeout


func spawn_line_to_player(spacing := 75.0):
	var start1 = loki.global_position
	var direction = (player.global_position - start1).normalized()
	var start2 = start1 + direction.orthogonal().normalized()*75
	var start3 = start1 + direction.orthogonal().normalized()*-75
	var distance = start1.distance_to(player.global_position)
	var steps = int(distance / spacing)
	Wwise.post_event_id(AK.EVENTS.ICICLE_APPEAR, self)
	
	for i in range(steps):
		var pos1 = start1 + direction * (i * spacing)
		spawn_spike(pos1)
		var pos2 = start2 + direction * (i * spacing)
		spawn_spike(pos2)
		var pos3 = start3 + direction * (i * spacing)
		spawn_spike(pos3)
		await get_tree().create_timer(.1).timeout

func spawn_circle(radius: float, count: int, player_position):
	for i in count:
		var angle = i * TAU / count
		var offset = Vector2(cos(angle), sin(angle)) * radius
		spawn_spike(player_position + offset)
		
func spawn_closing_circle(rings = 2):
	Wwise.post_event_id(AK.EVENTS.ICICLE_APPEAR, self)
	
	var player_position = player.global_position
	for i in range(rings, 0, -1):
		spawn_circle((50+ 75*i) ,(6 + 6*i), player_position)
		await get_tree().create_timer(2).timeout
	spawn_spike(player_position)

func spawn_opening_circle(rings = 3):
	Wwise.post_event_id(AK.EVENTS.ICICLE_APPEAR, self)
	
	var player_position = player.global_position
	spawn_spike(player_position)
	await get_tree().create_timer(1).timeout
	for i in range(1, rings):
		spawn_circle((50*i),(6*i), player_position)
		await get_tree().create_timer(1).timeout
		
func can_move_during():
	return false
