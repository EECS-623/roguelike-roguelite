extends Node
class_name ManaComponent

@export var max_mana: float = 100.0
@export var mana_regeneration_rate: float = 5.0  # Mana points per second
var current_mana: float

signal i_current_mana(value: float)  # Signal for mana changes
signal i_max_mana(value: float)      # Signal for max mana changes
signal mana_depleted                 # Signal when mana reaches zero
signal mana_restored                 # Signal when mana regenerates from zero

func _ready() -> void:
	current_mana = max_mana
	i_current_mana.emit(current_mana)
	i_max_mana.emit(max_mana)  # Fix: was i_max_health

func _process(delta: float) -> void:
	# Regenerate mana over time
	if current_mana < max_mana:
		var old_mana = current_mana
		current_mana = min(current_mana + mana_regeneration_rate * delta, max_mana)
		i_current_mana.emit(current_mana)
		
		# Signal if mana was depleted and is now available again
		if old_mana <= 0 && current_mana > 0:
			mana_restored.emit()

func use_mana(amount: float) -> bool:
	# Check if we have enough mana
	if current_mana >= amount:
		current_mana -= amount
		i_current_mana.emit(current_mana)
		
		# Signal if mana is depleted
		if current_mana == 0:
			mana_depleted.emit()
		
		return true
	return false

func set_max_mana(new_max: float) -> void:
	max_mana = new_max
	i_max_mana.emit(max_mana)
	
func increase_max_mana(amount: float) -> void:
	max_mana += amount
	i_max_mana.emit(max_mana)
