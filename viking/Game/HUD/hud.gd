extends CanvasLayer

@onready var health_bar = $Control/HealthBar
@onready var mana_bar = $Control/ManaBar
@onready var inventory_button = $Control/InventoryButton

var player
var health_component
var mana_component

func _ready():
	# Start hidden by default
	visible = false
	# Connect inventory button
	inventory_button.pressed.connect(_on_inventory_button_pressed)

func _on_inventory_button_pressed():
	Inventory.toggle_inventory()

# Call this function from any scene where you want the HUD to be visible
func connect_to_player():
	player = get_tree().get_first_node_in_group("player")
	print("HUD connecting to player: ", player != null)
	
	if player and player.has_node("HealthComponent"):
		# Clean up existing connections
		if is_instance_valid(health_component):
			if health_component.i_current_health.is_connected(_on_health_changed):
				health_component.i_current_health.disconnect(_on_health_changed)
			if health_component.i_max_health.is_connected(_on_max_health_changed):
				health_component.i_max_health.disconnect(_on_max_health_changed)
		
		# Connect to the player's health component
		health_component = player.get_node("HealthComponent")
		
		# Debug to verify health values
		print("Found health component - current health: ", health_component.current_health, 
			  " max health: ", health_component.max_health)
		
		# Connect signals
		health_component.i_current_health.connect(_on_health_changed)
		health_component.i_max_health.connect(_on_max_health_changed)
		
		# Initialize values
		health_bar.max_value = health_component.max_health
		health_bar.value = health_component.current_health
		print("Health bar initialized with: ", health_bar.value, "/", health_bar.max_value)
	
	# Connect to mana component
	if player and player.has_node("ManaComponent"):
		if is_instance_valid(mana_component):
			if mana_component.i_current_mana.is_connected(_on_mana_changed):
				mana_component.i_current_mana.disconnect(_on_mana_changed)
			if mana_component.i_max_mana.is_connected(_on_max_mana_changed):
				mana_component.i_max_mana.disconnect(_on_max_mana_changed)
			
		mana_component = player.get_node("ManaComponent")
		mana_component.i_current_mana.connect(_on_mana_changed)
		mana_component.i_max_mana.connect(_on_max_mana_changed)
			
		# Initialize the mana bar
		mana_bar.max_value = mana_component.max_mana
		mana_bar.value = mana_component.current_mana

func _on_health_changed(new_health):
	health_bar.value = new_health

func _on_max_health_changed(new_max_health):
	health_bar.max_value = new_max_health

func _on_mana_changed(new_mana: float) -> void:
	mana_bar.value = new_mana

func _on_max_mana_changed(new_max_mana: float) -> void:
	mana_bar.max_value = new_max_mana
