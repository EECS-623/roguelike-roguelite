extends Node

# Stat levels
const MAX_STAT_LEVEL = 5
const UPGRADE_COST = 2

var melee_damage_level = 0
var magic_ability_level = 0  
var speed_level = 0
var mana_regen_level = 0
var max_health_level = 0

# Stat upgrade amounts
const MELEE_DAMAGE_BOOST = 2    # Increases by 2 per level
const SPEED_BOOST = 30          # Increases by 30 per level
const MANA_REGEN_BOOST = 1.0    # Increases by 1.0 per level
const MAX_HEALTH_BOOST = 15     # Increases by 15 per level

# Signal when stats change
signal stats_changed

func _ready():
	# We don't need to find the inventory in _ready() since it's an autoload
	pass

func toggle_inventory():
	# Since Inventory is a global singleton, we can access it directly
	Inventory.toggle_visibility()

func upgrade_stat(stat_name: String, player) -> bool:
	# Check if player has enough runes
	if Global.xp < UPGRADE_COST:
		return false
		
	var success = false
	
	# Apply the upgrade based on stat type
	match stat_name:
		"melee_damage":
			if melee_damage_level < MAX_STAT_LEVEL:
				melee_damage_level += 1
				# Apply the stat boost to the player
				if player.has_node("PhysicalDamageComponent"):
					player.get_node("PhysicalDamageComponent").physical_damage += MELEE_DAMAGE_BOOST
				success = true
				
		"magic_ability":
			if magic_ability_level < MAX_STAT_LEVEL:
				magic_ability_level += 1
				# Wait on magic ability implementation for now
				success = true
				
		"speed":
			if speed_level < MAX_STAT_LEVEL:
				speed_level += 1
				if player.has_node("SpeedComponent"):
					player.get_node("SpeedComponent").set_speed(
						player.get_node("SpeedComponent").speed + SPEED_BOOST)
				success = true
				
		"mana_regen":
			if mana_regen_level < MAX_STAT_LEVEL:
				mana_regen_level += 1
				if player.has_node("ManaComponent"):
					player.get_node("ManaComponent").mana_regeneration_rate += MANA_REGEN_BOOST
				success = true
				
		"max_health":
			if max_health_level < MAX_STAT_LEVEL:
				max_health_level += 1
				if player.has_node("HealthComponent"):
					var health_component = player.get_node("HealthComponent")
					health_component.max_health += MAX_HEALTH_BOOST
					health_component.current_health += MAX_HEALTH_BOOST  # Also heal when upgrading max health
					health_component.i_max_health.emit(health_component.max_health)
					health_component.i_current_health.emit(health_component.current_health)
				success = true
	
	# If upgrade was successful, spend the runes
	if success:
		Global.xp -= UPGRADE_COST
		stats_changed.emit()
		
	return success

func get_stat_level(stat_name: String) -> int:
	match stat_name:
		"melee_damage": return melee_damage_level
		"magic_ability": return magic_ability_level
		"speed": return speed_level
		"mana_regen": return mana_regen_level
		"max_health": return max_health_level
	return 0
	
func get_stat_max_level(stat_name: String) -> int:
	return MAX_STAT_LEVEL
