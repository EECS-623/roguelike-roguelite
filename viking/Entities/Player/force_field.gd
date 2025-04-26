class_name ForceField extends SpecialAbilityComponent
signal ForceFieldOn
signal ForceFieldOff
@onready var player : Player = $"../.."
# Called when the node enters the scene tree for the first time.
@onready var original_player_color = player.modulate
@onready var mana_component = $"../../ManaComponent"
@onready var timer: Timer = Timer.new()  # Create a new Timer node

var mana_cost: float = 100.0  # Shield costs 100 mana
var shield_time: int = 3
func _ready() -> void:
	if Global.upgrade_level == 1:
		shield_time = 3
	elif Global.upgrade_level == 2:
		shield_time = 5
	$"../../Force_field".modulate.a = 0.0
	add_child(timer)  # Add Timer as a child of this node
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))  # Connect the timer's timeout signal to a function
	# Make sure Timer is inside the scene tree before starting it
	timer.autostart = false  # Ensure the timer doesn't start automatically when created
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("right_click") and Global.patron_god == 2:
		##$"../../Force_field".modulate.a = 1.0
		#player.modulate = Color(0.25, 0.5, 1, 1) #LIGHT BLUE
		#ForceFieldOn.emit()
		#await get_tree().create_timer(3).timeout
		##$"../../Force_field".modulate.a = 0
		#player.modulate = original_player_color
		#ForceFieldOff.emit()

func cast_ability() -> bool:
	# Try to use mana first
	if !mana_component.use_mana(mana_cost):
		return false # Not enough mana
	
	# move over ability logic here
	if Input.is_action_just_pressed("right_click") and Global.patron_god == 2:
		#$"../../Force_field".modulate.a = 1.0
		#player.modulate = Color(0.25, 0.5, 1, 1) #LIGHT BLUE
		ForceFieldOn.emit()
		timer.start(shield_time)
		$"../../Force_field".modulate.a = 1
		#player.modulate = original_player_color
		#ForceFieldOff.emit()
	
	
	
	return true # this will be at the very end of the function
func _on_timer_timeout() -> void:
	# Actions that happen after the 3-second delay
	$"../../Force_field".modulate.a = 0
	#player.modulate = original_player_color
	ForceFieldOff.emit()
