extends Node
class_name ManaComponent

@export var max_mana: float = 100.0
@export var mana_regeneration_rate: float = 10.0  # Mana points per second
var current_mana: float

signal i_current_mana(value: float)  # Signal for mana changes
signal i_max_mana(value: float)      # Signal for max mana changes
signal flash_red_requested           # Signal for flashing the mana bar red

func _ready() -> void:
	current_mana = max_mana
	i_current_mana.emit(current_mana)
	i_max_mana.emit(max_mana)

func _process(delta: float) -> void:
	# Regenerate mana over time
	if current_mana < max_mana:
		current_mana = min(current_mana + mana_regeneration_rate * delta, max_mana)
		i_current_mana.emit(current_mana)

func use_mana(amount: float) -> bool:
	# Check if we have enough mana
	if current_mana >= amount:
		current_mana -= amount
		i_current_mana.emit(current_mana)
		return true
	return false

# Call this when there's not enough mana to cast an ability
func flash_mana_bar_red() -> void:
	flash_red_requested.emit()
