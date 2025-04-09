class_name ForceField extends SpecialAbilityComponent
signal ForceFieldOn
signal ForceFieldOff
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../Force_field".modulate.a = 0.0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ForceField"):
		$"../../Force_field".modulate.a = 1.0
		ForceFieldOn.emit()
		await get_tree().create_timer(3).timeout
		$"../../Force_field".modulate.a = 0
		ForceFieldOff.emit()
