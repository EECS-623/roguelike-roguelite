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

@onready var melee_damage_max = $Control/MeleeDamageMAX
@onready var magic_ability_max = $Control/MagicAbilityMAX
@onready var speed_max = $Control/SpeedMAX    
@onready var mana_regen_max = $Control/ManaRegenMAX
@onready var max_health_max = $Control/MaxHealthMAX

@onready var rune_count_label = $Control/RuneCount

# Key and artifact references
@onready var forrest_key1 = $Control/ForrestKey1
@onready var forrest_key2 = $Control/ForrestKey2
@onready var forrest_key3 = $Control/ForrestKey3
@onready var forrest_artifact = $Control/ForrestArtifact
@onready var ice_key1 = $Control/IceKey1
@onready var ice_key2 = $Control/IceKey2
@onready var ice_key3 = $Control/IceKey3
@onready var ice_artifact = $Control/IceArtifact

var player
var last_checked_runes = 0
var health_component
var speed_component
var mana_component
var magic_component
var physical_damage_component

func _ready():
	# Start hidden by default
	visible = false
	
	# Hide all MAX labels initially
	melee_damage_max.visible = false
	magic_ability_max.visible = false
	speed_max.visible = false
	mana_regen_max.visible = false
	max_health_max.visible = false
	
	# Hide all keys and artifacts initially
	hide_all_keys_and_artifacts()
	
	# Connect button signals
	melee_damage_btn.pressed.connect(_on_melee_damage_upgrade_pressed)
	magic_ability_btn.pressed.connect(_on_magic_ability_upgrade_pressed)
	speed_btn.pressed.connect(_on_speed_upgrade_pressed)
	mana_regen_btn.pressed.connect(_on_mana_regen_upgrade_pressed)
	max_health_btn.pressed.connect(_on_max_health_upgrade_pressed)
	
	# Connect to stat changes
	InventoryManager.stats_changed.connect(update_display)

func hide_all_keys_and_artifacts():
	# Hide all keys and artifacts
	hide_forrest_keys_and_artifacts()
	ice_key1.visible = false
	ice_key2.visible = false
	ice_key3.visible = false
	ice_artifact.visible = false

func hide_forrest_keys_and_artifacts():
	# Hide Forest keys and artifact
	forrest_key1.visible = false
	forrest_key2.visible = false
	forrest_key3.visible = false
	forrest_artifact.visible = false

func _process(_delta):
	if visible:
		# Only update rune count when visible to save processing
		rune_count_label.text = str(Global.xp)
		
		# Check if buttons need to be updated (e.g., if runes were gained/lost)
		var current_runes = Global.xp
		if current_runes != last_checked_runes:
			last_checked_runes = current_runes
			_update_buttons()

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
		connect_to_player()
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
	
	# Update rune count directly from Global
	rune_count_label.text = str(Global.xp)
	
	# Update buttons
	_update_buttons()

func _update_buttons():
	var has_enough_runes = Global.xp >= InventoryManager.UPGRADE_COST
	
	# Update melee damage button
	var melee_level = InventoryManager.get_stat_level("melee_damage")
	if melee_level >= InventoryManager.MAX_STAT_LEVEL:
		melee_damage_btn.visible = false
		melee_damage_max.visible = true
	else:
		melee_damage_btn.visible = has_enough_runes
		melee_damage_max.visible = false
	
	# Update magic ability button
	var magic_level = InventoryManager.get_stat_level("magic_ability")
	if magic_level >= InventoryManager.MAX_STAT_LEVEL:
		magic_ability_btn.visible = false
		magic_ability_max.visible = true
	else:
		magic_ability_btn.visible = has_enough_runes
		magic_ability_max.visible = false
	
	# Update speed button
	var speed_level = InventoryManager.get_stat_level("speed")
	if speed_level >= InventoryManager.MAX_STAT_LEVEL:
		speed_btn.visible = false
		speed_max.visible = true
	else:
		speed_btn.visible = has_enough_runes
		speed_max.visible = false
	
	# Update mana regen button
	var mana_level = InventoryManager.get_stat_level("mana_regen")
	if mana_level >= InventoryManager.MAX_STAT_LEVEL:
		mana_regen_btn.visible = false
		mana_regen_max.visible = true
	else:
		mana_regen_btn.visible = has_enough_runes
		mana_regen_max.visible = false
	
	# Update max health button
	var health_level = InventoryManager.get_stat_level("max_health")
	if health_level >= InventoryManager.MAX_STAT_LEVEL:
		max_health_btn.visible = false
		max_health_max.visible = true
	else:
		max_health_btn.visible = has_enough_runes
		max_health_max.visible = false

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
