extends SpecialAbilityComponent
@onready var player : Player = $"../.."
# Called when the node enters the scene tree for the first time.

@onready var mana_component = $"../../ManaComponent"

@onready var camera = $"../../Camera2D"

var teleport = true
var camera_moving = false

var mana_cost: float = 40.0  # Teleport costs 40 mana
var max_distance = 500
var pos
var distance
var direction

func _ready() -> void:
	pass # Replace with function body.

				#print(camera.global_position.distance_to(camera.get_target_position()))
				#if camera.global_position.distance_to(camera.get_target_position()) < 1:
					#camera.position_smoothing_enabled = false
	#teleport anywhere script
	#if teleport:
		#position = get_global_mouse_position()
		#teleport = false
		#await get_tree().create_timer(3).timeout
		#teleport = true
		#this was the teleport where it took you anywhere
		
func upgrade_ability():
	max_distance += 50

func cast_ability() -> bool:
	if teleport == false or camera_moving:
		return false
	
	pos = player.get_global_mouse_position()
	distance = player.global_position.distance_to(pos)
	direction = (pos - player.global_position).normalized()
	
	#Trying to teleport into something
	if position_blocked(pos):
		return false
	
	#too far to teleport
	if distance > max_distance:
		return false
	
	mana_cost = lerp(15.0, 50.0, distance / max_distance)
	
	# Try to use mana first
	if (mana_component.current_mana - mana_cost < 0) or Global.teleport_banned:
		return false # Not enough mana or teleport banned like in valhalla
		
	teleport = false
	if Global.upgrade_level == 2:
		tele_slash()
	
	camera.position_smoothing_enabled = false
	var old_camera_position = camera.global_position
	
	player.get_node("AnimationPlayer").play("Teleport")
	await get_tree().create_timer(.1).timeout
	player.global_position = pos
	
	start_camera_lerp(old_camera_position, player.global_position)
	
	mana_component.use_mana(mana_cost)
	return true 

func start_camera_lerp(from_position: Vector2, to_position: Vector2):
	camera_moving = true
	await async_camera_lerp(from_position, get_camera_clamped_position(to_position))
	camera_moving = false

func async_camera_lerp(from_position: Vector2, to_position: Vector2):
	var lerp_time := 0.0
	var duration := 0.3
	
	while lerp_time < duration:
		lerp_time += get_process_delta_time()
		var t := lerp_time / duration
		camera.global_position = from_position.lerp(to_position, t)
		await get_tree().process_frame
	
	camera.global_position = to_position
	camera.position_smoothing_enabled = true
	teleport = true

func position_blocked(pos: Vector2) -> bool:
	var shape_node = player.get_node("CollisionShape2D")
	var shape = shape_node.shape
	if shape == null:
		return false

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = shape.duplicate()
	query.transform = Transform2D(0, pos) 
	query.exclude = [player]
	query.collide_with_bodies = true
	query.collide_with_areas = true

	# Run the query
	var space_state = player.get_world_2d().get_direct_space_state()
	var result = space_state.intersect_shape(query)

	# Check result
	for collision in result:
		var col = collision.collider
		print(col)
		if col is StaticBody2D or col is CollisionShape2D or col is TileMapLayer:
			return true

	return false

func get_camera_clamped_position(pos: Vector2) -> Vector2:
	var screen_size = get_viewport().get_visible_rect().size / 2
	var clamped = pos
	
	clamped.x = clamp(pos.x, camera.limit_left + screen_size.x, camera.limit_right - screen_size.x)
	clamped.y = clamp(pos.y, camera.limit_top + screen_size.y, camera.limit_bottom - screen_size.y)

	return clamped

func tele_slash():
	var rect_shape = RectangleShape2D.new()
	rect_shape.extents = Vector2(distance/2, 50)

	# Transform2D(angle, origin)
	var angle = direction.angle()
	var origin = (player.global_position + pos) * 0.5
	var xform = Transform2D(angle, origin)

	var query = PhysicsShapeQueryParameters2D.new()
	query.shape = rect_shape
	query.transform = xform
	query.exclude = [player]				# don't hit yourself
	query.collide_with_bodies = true		# include PhysicsBody2D
	query.collide_with_areas = true			# include Area2D (if your Hitbox is one)
	query.collision_mask = (1 << 0) | (1 << 2)  # Layers 1 and 3
# make sure this matches your ENEMY layer
	
	# Actually do the query (limit to 32 hits just in case)
	var results = player.get_world_2d().direct_space_state.intersect_shape(query, 32)
	print("Teleport hit count: ", results.size())


	# ────── 2) APPLY DAMAGE ──────
	#var enemies_to_damage = []
	for r in results:
		var enemy = r.collider
		print(enemy)

		# If the enemy *has a healthcomponent*, you can damage it:
		if enemy != null:
			var health = enemy.get_node_or_null("HealthComponent")
			if health:
				health.take_damage(20)
