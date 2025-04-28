extends CanvasLayer

@onready var health_bar = $Control/HealthBar
@onready var mana_bar = $Control/ManaBar
@onready var inventory_button = $Control/InventoryButton
var connected: bool = false
var player
var health_component
var mana_component
var is_flashing = false

func _ready():
	# Start hidden by default
	visible = false
	# Connect inventory button
	inventory_button.pressed.connect(_on_inventory_button_pressed)
	
	# Connect to scene tree signals for detecting scene changes
	get_tree().root.connect("child_entered_tree", _on_scene_changed)

func _process(delta):
	# Try to find player if not connected
	if !connected or player == null:
		call_deferred("connect_to_player")

func _on_scene_changed(node):
	# When a new scene is added to the tree, reconnect to player
	if node.get_class() == "Node2D" or node.get_class() == "Node3D":  # Main scene nodes
		print("New scene detected, reconnecting HUD to player")
		# Reset connection state
		connected = false
		player = null
		health_component = null
		mana_component = null
		call_deferred("connect_to_player")

func _on_inventory_button_pressed():
	# Toggle the inventory directly
	Inventory.toggle_visibility()

# Call this function from any scene where you want the HUD to be visible
func connect_to_player():
	# Find the player in the scene
	var new_player = get_tree().get_first_node_in_group("player")
	
	# Only proceed if we found a valid player
	if new_player == null:
		return
	
	# If we found the same player we're already connected to, no need to reconnect
	if connected and player == new_player:
		return
	
	# Clean up old connections
	if health_component != null:
		if health_component.i_current_health.is_connected(_on_health_changed):
			health_component.i_current_health.disconnect(_on_health_changed)
		if health_component.i_max_health.is_connected(_on_max_health_changed):
			health_component.i_max_health.disconnect(_on_max_health_changed)
	
	if mana_component != null:
		if mana_component.i_current_mana.is_connected(_on_mana_changed):
			mana_component.i_current_mana.disconnect(_on_mana_changed)
		if mana_component.i_max_mana.is_connected(_on_max_mana_changed):
			mana_component.i_max_mana.disconnect(_on_max_mana_changed)
		if mana_component.flash_red_requested.is_connected(_on_flash_mana_red):
			mana_component.flash_red_requested.disconnect(_on_flash_mana_red)
	
	# Store the new player
	player = new_player
	connected = false
	
	print("HUD connecting to player: ", player != null)
	
	# Connect to health component
	if player and player.has_node("HealthComponent"):
		health_component = player.get_node("HealthComponent")
		health_component.i_current_health.connect(_on_health_changed)
		health_component.i_max_health.connect(_on_max_health_changed)
		
		# Force update with current values
		_on_max_health_changed(health_component.max_health)
		_on_health_changed(health_component.current_health)
		print("HUD connected to health component: ", health_component.current_health, "/", health_component.max_health)
	
	# Connect to mana component
	if player and player.has_node("ManaComponent"):
		mana_component = player.get_node("ManaComponent")
		mana_component.i_current_mana.connect(_on_mana_changed)
		mana_component.i_max_mana.connect(_on_max_mana_changed)
		mana_component.flash_red_requested.connect(_on_flash_mana_red)
		
		# Force update with current values
		_on_max_mana_changed(mana_component.max_mana)
		_on_mana_changed(mana_component.current_mana)
		print("HUD connected to mana component: ", mana_component.current_mana, "/", mana_component.max_mana)
	
	connected = true

func _on_health_changed(new_health):
	health_bar.value = new_health

func _on_max_health_changed(new_max_health):
	health_bar.max_value = new_max_health

func _on_mana_changed(new_mana: float) -> void:
	mana_bar.value = new_mana

func _on_max_mana_changed(new_max_mana: float) -> void:
	mana_bar.max_value = new_max_mana

func _on_flash_mana_red():
	if is_flashing:
		return  # Prevent overlapping flashes

	is_flashing = true  # Lock flashing

	print("Flash mana red triggered")

	# Store the original tint once
	var original_tint = mana_bar.get("tint_progress")

	# Define the flash color (bright red)
	var flash_color = Color(1, 0, 0)  # Red

	# Flash sequence
	for i in range(3):
		mana_bar.set("tint_progress", flash_color)
		await get_tree().create_timer(0.1).timeout
		mana_bar.set("tint_progress", original_tint)
		await get_tree().create_timer(0.1).timeout

	is_flashing = false  # Unlock flashing
