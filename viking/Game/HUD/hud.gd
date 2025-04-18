extends CanvasLayer

@onready var health_bar = $Control/HealthBar
@onready var mana_bar = $Control/ManaBar

var player
var health_component
var mana_component

func _ready():
	# Initialize in a hidden state (for non-gameplay scenes)
	visible = false
	
	# Wait for scene changes
	get_tree().root.connect("ready", _on_scene_changed)

func _on_scene_changed():
	# Check if we're in a gameplay scene (one with a player)
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		# We're in a gameplay scene with a player
		visible = true
		_connect_to_player()
	else:
		# We're in a menu or other scene without a player
		visible = false
		
func _connect_to_player():
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
		health_bar.max_value = health_component.max_health
		health_bar.value = health_component.current_health
		
	# Similar for mana if you're implementing that

func _on_health_changed(new_health):
	# Update health bar when health changes
	health_bar.value = new_health

func _on_max_health_changed(new_max_health):
	# Update max value if max health changes
	health_bar.max_value = new_max_health
