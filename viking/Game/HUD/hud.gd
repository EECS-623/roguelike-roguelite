extends CanvasLayer

@onready var health_bar = $Control/HealthBar
@onready var mana_bar = $Control/ManaBar

var player
var health_component
var mana_component

func _ready():
	# Start hidden by default
	visible = false

# Call this function from any scene where you want the HUD to be visible
# Add this public method
# Replace the current connect_to_player function with this improved version
func connect_to_player():
	player = get_tree().get_first_node_in_group("player")
	print("HUD connecting to player: ", player != null)
	
	if player and player.has_node("HealthComponent"):
		# Clean up existing connections
		if health_component:
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

func _on_health_changed(new_health):
	# Update health bar when health changes
	health_bar.value = new_health

func _on_max_health_changed(new_max_health):
	# Update max value if max health changes
	health_bar.max_value = new_max_health
	
