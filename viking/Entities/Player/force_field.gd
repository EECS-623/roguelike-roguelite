class_name ForceField extends SpecialAbilityComponent
signal ForceFieldOn
signal ForceFieldOff
@onready var player : Player = $"../.."
# Called when the node enters the scene tree for the first time.

@onready var original_player_color = player.modulate

func _ready() -> void:
	$"../../Force_field".modulate.a = 0.0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("right_click") and Global.patron_god == 2:
		#$"../../Force_field".modulate.a = 1.0
		player.modulate = Color(0.25, 0.5, 1, 1) #LIGHT BLUE
		ForceFieldOn.emit()
		await get_tree().create_timer(3).timeout
		#$"../../Force_field".modulate.a = 0
		player.modulate = original_player_color
		ForceFieldOff.emit()
