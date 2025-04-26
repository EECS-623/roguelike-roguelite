extends CanvasLayer

@onready var melee_damage_bar = $Control/MeleeDamageBar
@onready var magic_ability_bar = $Control/MagicAbilityBar
@onready var speed_bar = $Control/SpeedBar    
@onready var mana_regen_bar = $Control/ManaRegenBar
@onready var max_health_bar = $Control/MaxHealthBar   
 
@onready var melee_damage_btn = $Control/MeleeDamageButton
@onready var magic_ability_btn = $Control/MagicAbilityButton
@onready var speed_btn = $Control/SpeedButton
@onready var mana_regen_btn = $Control/ManaRegenButton
@onready var max_health_btn = $Control/MaxHealthButton
	
@onready var rune_count_label = $Control/RuneCount     

var player
var health_component
var speed_component
var mana_componenet


# Stat max values
const MAX_HEALTH = 200
const MAX_SPEED = 300

func _ready():
	# Start hidden by default
	visible = false
	
	# Connect button signals
	health_upgrade_btn.pressed.connect(_on_health_upgrade_pressed)
	speed_upgrade_btn.pressed.connect(_on_speed_upgrade_pressed)

# This is the missing function that was causing the error
func connect_to_player():
	player = get_tree().get_first_node_in_group("player")
	print("Inventory connecting to player: ", player != null)
	
	if player:
		# Connect to health component
		if player.has_node("HealthComponent"):
			health_component = player.get_node("HealthComponent")
			print("Found health component - max health: ", health_component.max_health)
		
		# Connect to speed component
		if player.has_node("SpeedComponent"):
			speed_component = player.get_node("SpeedComponent")
			print("Found speed component - speed: ", speed_component.speed)
		
		# Update the UI bars
		update_display()
		
func toggle_visibility():
	visible = !visible
	
	if visible:
		update_display()

func update_display():
	if !player:
		return
		
	# Update health bar
	if health_component:
		health_bar.max_value = MAX_HEALTH
		health_bar.value = health_component.max_health
		
	# Update speed bar
	if speed_component:
		speed_bar.max_value = MAX_SPEED
		speed_bar.value = speed_component.speed
		
	# Update rune count from player's XP
	var xp_label = player.get_node_or_null("CanvasLayer/XP")
	if xp_label:
		var rune_count = int(xp_label.text)
		rune_count_label.text = "Runes: " + str(rune_count)
	
	# Update button states
	_update_buttons()

func _update_buttons():
	var xp_label = player.get_node_or_null("CanvasLayer/XP") 
	var runes = 0
	if xp_label:
		runes = int(xp_label.text)
	
	# Disable upgrade buttons if no runes or max stat reached
	health_upgrade_btn.disabled = runes <= 0 || health_component.max_health >= MAX_HEALTH
	speed_upgrade_btn.disabled = runes <= 0 || speed_component.speed >= MAX_SPEED
	
	# Change to "Max" if reached max
	if health_component.max_health >= MAX_HEALTH:
		health_upgrade_btn.text = "Max"
	else:
		health_upgrade_btn.text = "Upgrade"
	
	if speed_component.speed >= MAX_SPEED:
		speed_upgrade_btn.text = "Max"
	else:
		speed_upgrade_btn.text = "Upgrade"

func _on_health_upgrade_pressed():
	var xp_label = player.get_node_or_null("CanvasLayer/XP")
	if !xp_label:
		return
		
	var runes = int(xp_label.text)
	
	if runes > 0 and health_component.max_health < MAX_HEALTH:
		# Increase max health by 10 (without healing)
		health_component.max_health += 10
		health_component.i_max_health.emit(health_component.max_health)
		
		# Spend a rune (update XP)
		xp_label.text = str(runes - 1)
		
		# Update the display
		update_display()

func _on_speed_upgrade_pressed():
	var xp_label = player.get_node_or_null("CanvasLayer/XP")
	if !xp_label:
		return
		
	var runes = int(xp_label.text)
	
	if runes > 0 and speed_component.speed < MAX_SPEED:
		# Increase speed by 10
		speed_component.set_speed(speed_component.speed + 10)
		
		# Spend a rune (update XP)
		xp_label.text = str(runes - 1)
		
		# Update the display
		update_display()
