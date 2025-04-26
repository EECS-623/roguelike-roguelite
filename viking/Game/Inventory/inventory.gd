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
var mana_component
var magic_component
var physical_damage_component

func _ready():
	# Start hidden by default
	visible = false
	
	# Connect button signals
	melee_damage_btn.pressed.connect(_on_melee_damage_upgrade_pressed)
	magic_ability_btn.pressed.connect(_on_magic_ability_upgrade_pressed)
	speed_btn.pressed.connect(_on_speed_upgrade_pressed)
	mana_regen_btn.pressed.connect(_on_mana_regen_upgrade_pressed)
	max_health_btn.pressed.connect(_on_max_health_upgrade_pressed)
	
	# Connect to stat changes
	InventoryManager.stats_changed.connect(update_display)

func connect_to_player():
	player = get_tree().get_first_node_in_group("player")
	
	if player:
		# Connect to components
		health_component = player.get_node_or_null("HealthComponent")
		speed_component = player.get_node_or_null("SpeedComponent")
		mana_component = player.get_node_or_null("ManaComponent")
		magic_component = player.get_node_or_null("MagicDamageComponent")
		physical_damage_component = player.get_node_or_null("PhysicalDamageComponent")

# Used by both the HUD inventory button and inventory_manager
func toggle_visibility():
	visible = !visible
	
	if visible:
		update_display()

func update_display():
	if !player:
		return
		
	# Update progress bars
	melee_damage_bar.max_value = InventoryManager.MAX_STAT_LEVEL
	melee_damage_bar.value = InventoryManager.get_stat_level("melee_damage")
	
	magic_ability_bar.max_value = InventoryManager.MAX_STAT_LEVEL
	magic_ability_bar.value = InventoryManager.get_stat_level("magic_ability")
	
	speed_bar.max_value = InventoryManager.MAX_STAT_LEVEL
	speed_bar.value = InventoryManager.get_stat_level("speed")
	
	mana_regen_bar.max_value = InventoryManager.MAX_STAT_LEVEL
	mana_regen_bar.value = InventoryManager.get_stat_level("mana_regen")
	
	max_health_bar.max_value = InventoryManager.MAX_STAT_LEVEL
	max_health_bar.value = InventoryManager.get_stat_level("max_health")
	
	# Update rune count
	rune_count_label.text = "Runes: " + str(player.xp)
	
	# Update buttons
	_update_buttons()

func _update_buttons():
	# Check rune count
	var has_enough_runes = player.xp >= InventoryManager.UPGRADE_COST
	
	# Update melee damage button
	var melee_level = InventoryManager.get_stat_level("melee_damage")
	var melee_max = InventoryManager.get_stat_max_level("melee_damage")
	if melee_level >= melee_max:
		melee_damage_btn.text = "MAX"
		melee_damage_btn.disabled = true
	else:
		melee_damage_btn.text = "Upgrade (" + str(InventoryManager.UPGRADE_COST) + " runes)"
		melee_damage_btn.disabled = !has_enough_runes
	
	# Update magic ability button
	var magic_level = InventoryManager.get_stat_level("magic_ability")
	var magic_max = InventoryManager.get_stat_max_level("magic_ability")
	if magic_level >= magic_max:
		magic_ability_btn.text = "MAX"
		magic_ability_btn.disabled = true
	else:
		magic_ability_btn.text = "Upgrade (" + str(InventoryManager.UPGRADE_COST) + " runes)"
		magic_ability_btn.disabled = !has_enough_runes
	
	# Update speed button
	var speed_level = InventoryManager.get_stat_level("speed")
	var speed_max = InventoryManager.get_stat_max_level("speed")
	if speed_level >= speed_max:
		speed_btn.text = "MAX"
		speed_btn.disabled = true
	else:
		speed_btn.text = "Upgrade (" + str(InventoryManager.UPGRADE_COST) + " runes)"
		speed_btn.disabled = !has_enough_runes
	
	# Update mana regen button
	var mana_level = InventoryManager.get_stat_level("mana_regen")
	var mana_max = InventoryManager.get_stat_max_level("mana_regen")
	if mana_level >= mana_max:
		mana_regen_btn.text = "MAX"
		mana_regen_btn.disabled = true
	else:
		mana_regen_btn.text = "Upgrade (" + str(InventoryManager.UPGRADE_COST) + " runes)"
		mana_regen_btn.disabled = !has_enough_runes
	
	# Update max health button
	var health_level = InventoryManager.get_stat_level("max_health")
	var health_max = InventoryManager.get_stat_max_level("max_health")
	if health_level >= health_max:
		max_health_btn.text = "MAX"
		max_health_btn.disabled = true
	else:
		max_health_btn.text = "Upgrade (" + str(InventoryManager.UPGRADE_COST) + " runes)"
		max_health_btn.disabled = !has_enough_runes

func _on_melee_damage_upgrade_pressed():
	InventoryManager.upgrade_stat("melee_damage", player)
	update_display()

func _on_magic_ability_upgrade_pressed():
	InventoryManager.upgrade_stat("magic_ability", player)
	update_display()

func _on_speed_upgrade_pressed():
	InventoryManager.upgrade_stat("speed", player)
	update_display()

func _on_mana_regen_upgrade_pressed():
	InventoryManager.upgrade_stat("mana_regen", player)
	update_display()

func _on_max_health_upgrade_pressed():
	InventoryManager.upgrade_stat("max_health", player)
	update_display()

func _on_close_button_pressed():
	toggle_visibility()
