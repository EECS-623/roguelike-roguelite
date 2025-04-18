extends CanvasLayer

#@onready var health_bar = $Control/HealthBar
@onready var mana_bar = $Control/ManaBar

var player
var health_component
var mana_component

func _ready():
	# Start hidden by default
	visible = false

# Call this function from any scene where you want the HUD to be visible
func connect_to_player():
	player = get_tree().get_first_node_in_group("player")
	
	if player and player.has_node("HealthComponent"):
		# Disconnect any existing connections to prevent duplicates
		if health_component:
			health_component.i_current_health.disconnect(_on_health_changed) if health_component.i_current_health.is_connected(_on_health_changed) else null
			health_component.i_max_health.disconnect(_on_max_health_changed) if health_component.i_max_health.is_connected(_on_max_health_changed) else null
		
		# Connect to the new player
		health_component = player.get_node("HealthComponent")
		health_component.i_current_health.connect(_on_health_changed)
		health_component.i_max_health.connect(_on_max_health_changed)
		
		# Initialize the health bar
		$Control/HealthBar.max_value = health_component.max_health
		$Control/HealthBar.value = health_component.current_health

func _on_health_changed(new_health):
	# Update health bar when health changes
	$Control/HealthBar.value = new_health

func _on_max_health_changed(new_max_health):
	# Update max value if max health changes
	$Control/HealthBar.max_value = new_max_health
