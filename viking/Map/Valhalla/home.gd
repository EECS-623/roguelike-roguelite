extends Node2D

@export var player: PackedScene = preload("res://Entities/Player/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !PlayerManager.player:
		var my_player = player.instantiate()
		PlayerManager.player = my_player
		
	get_tree().current_scene.add_child(PlayerManager.player)
	PlayerManager.player.global_position = Vector2(110,0)
	Wwise.post_event_id(AK.EVENTS.GAMESTART_MENU, self)
	Wwise.post_event_id(AK.EVENTS.VALHALLA, self)
	var cam = PlayerManager.player.get_node("Camera2D")
	cam.limit_left = -900
	cam.limit_right = 900
	cam.limit_top = -600
	cam.limit_bottom = 600
	HUD.visible = true
	
	# Apply patron-specific stat bonuses
	if Global.patron_stat_initialized == false:
		apply_patron_bonus()
		Global.patron_stat_initialized = true
	
	# Wait a moment for the player to be fully initialized
	await get_tree().create_timer(0.1).timeout
	# Connect the HUD to player
	if not(HUD.connected):
		HUD.connect_to_player()

# Apply patron-specific health stat bonus if selected immediately when player enters scene
func apply_patron_bonus() -> void:
	var health_component = PlayerManager.player.get_node_or_null("HealthComponent")
	var speed_component = PlayerManager.player.get_node_or_null("SpeedComponent")
	var physical_damage_component = PlayerManager.player.get_node_or_null("PhysicalDamageComponent")
	Inventory.connect_to_player()
	
		# Apply difficulty-based health adjustment
	if health_component:
		# Set base health according to difficulty level
		match Global.difficulty_level:
			"easy":
				health_component.max_health = 250.0
			"medium":
				health_component.max_health = 100.0
			"unbeatable":
				health_component.max_health = 50.0
		
		# Update current health to match new max health
		health_component.current_health = health_component.max_health
		
		# Emit signals to update UI
		health_component.i_max_health.emit(health_component.max_health)
		health_component.i_current_health.emit(health_component.current_health)
	
	Global.xp += 4 # these runes will be immediately spent
	
	# Apply melee damage boost for Patron 1 (Thor)
	if Global.patron_god == 1 and physical_damage_component:
		Inventory._on_melee_damage_upgrade_pressed()
		Inventory._on_melee_damage_upgrade_pressed()
		check_melee_damage_upgrade()
	
	# Apply the health boost for Patron 2 (Tyr) (and add to initial health)
	elif Global.patron_god == 2 and health_component:
		Inventory._on_max_health_upgrade_pressed()
		Inventory._on_max_health_upgrade_pressed()
		health_component.current_health += InventoryManager.MAX_HEALTH_BOOST
		health_component.current_health += InventoryManager.MAX_HEALTH_BOOST
		check_max_health_upgrade()

	# Apply speed boost for Patron 3 (Freya) 
	elif Global.patron_god == 3 and speed_component:
		Inventory._on_speed_upgrade_pressed()
		Inventory._on_speed_upgrade_pressed()
		check_speed_upgrade()

# Function to check if max health upgrade was applied correctly
func check_max_health_upgrade() -> void:
	var health_component = PlayerManager.player.get_node_or_null("HealthComponent")
	var base_max_health
	if health_component:
		match Global.difficulty_level:
			"easy":
				base_max_health = 250.0
			"medium":
				base_max_health = 100.0
			"unbeatable":
				base_max_health = 50.0
		var expected_bonus = InventoryManager.max_health_level * InventoryManager.MAX_HEALTH_BOOST
		var expected_max_health = base_max_health + expected_bonus
		
		print("------- MAX HEALTH CHECK -------")
		print("Max health level: ", InventoryManager.max_health_level)
		print("Health boost per level: ", InventoryManager.MAX_HEALTH_BOOST)
		print("Base max health: ", base_max_health)
		print("Expected max health: ", expected_max_health)
		print("Actual max health: ", health_component.max_health)
		print("Current health: ", health_component.current_health)
		
		if health_component.max_health == expected_max_health:
			print("✓ Max health upgrade working correctly!")
		else:
			print("✗ Max health upgrade not working as expected!")
			print("Difference: ", health_component.max_health - expected_max_health)
		print("-------------------------------")
	else:
		print("ERROR: Couldn't find HealthComponent on player")

# Function to check if melee damage upgrade was applied correctly
func check_melee_damage_upgrade() -> void:
	var physical_damage_component = PlayerManager.player.get_node_or_null("PhysicalDamageComponent")
	if physical_damage_component:
		var base_damage = 10  # Assuming base damage is 10
		var expected_bonus = InventoryManager.melee_damage_level * InventoryManager.MELEE_DAMAGE_BOOST
		var expected_damage = base_damage + expected_bonus
		
		print("------- MELEE DAMAGE CHECK -------")
		print("Melee damage level: ", InventoryManager.melee_damage_level)
		print("Damage boost per level: ", InventoryManager.MELEE_DAMAGE_BOOST)
		print("Base damage: ", base_damage)
		print("Expected damage: ", expected_damage)
		print("Actual damage: ", physical_damage_component.physical_damage)
		
		if physical_damage_component.physical_damage == expected_damage:
			print("✓ Melee damage upgrade working correctly!")
		else:
			print("✗ Melee damage upgrade not working as expected!")
			print("Difference: ", physical_damage_component.physical_damage - expected_damage)
		print("-------------------------------")
	else:
		print("ERROR: Couldn't find PhysicalDamageComponent on player")

# Function to check if speed upgrade was applied correctly
func check_speed_upgrade() -> void:
	var speed_component = PlayerManager.player.get_node_or_null("SpeedComponent")
	if speed_component:
		var base_speed = 300  # Assuming base speed is 100
		var expected_bonus = InventoryManager.speed_level * InventoryManager.SPEED_BOOST
		var expected_speed = base_speed + expected_bonus
		
		print("------- SPEED CHECK -------")
		print("Speed level: ", InventoryManager.speed_level)
		print("Speed boost per level: ", InventoryManager.SPEED_BOOST)
		print("Base speed: ", base_speed)
		print("Expected speed: ", expected_speed)
		print("Actual speed: ", speed_component.speed)
		
		if speed_component.speed == expected_speed:
			print("✓ Speed upgrade working correctly!")
		else:
			print("✗ Speed upgrade not working as expected!")
			print("Difference: ", speed_component.speed - expected_speed)
		print("-------------------------------")
	else:
		print("ERROR: Couldn't find SpeedComponent on player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_area_2d_tree_travel_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		
		remove_child(body)
		#SceneTransitionManager.fade_to_scene("res://Map/Valhalla/Tree_Scene/tree_scene.tscn")
		get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/Tree_Scene/tree_scene.tscn")


func _on_area_2d_portal_travel_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		remove_child(body)
		#PlayerManager.player.global_position = Vector2(0,520)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/Portal_Scene/Portal_Scene.tscn")


func _on_house_portal_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#Wwise.post_event_id(AK.EVENTS.SPAWN, self)
		#$CollisionShape2D.set_deferred("disabled", true)
		remove_child(body)
		#PlayerManager.player.global_position = Vector2(0,520)
		get_tree().call_deferred("change_scene_to_file", "res://Map/Valhalla/HouseScene/HouseWarning.tscn")
