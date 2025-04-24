class_name FreezeEffect extends StatusEffect

@export var slow_factor: float = 0.5

var target

func _ready() -> void:
	timer = 2.0

func update(delta):
	timer -= delta
	if timer <= 0:
		remove()
		queue_free()

func apply(_target):
	if _target.is_in_group("player"):
		target = _target
		target.speed_component.set_multiplier(slow_factor)
		target.modulate = Color(0.4, 0.7, 1.0)

func remove():
	if target and target.is_in_group("player"):
		target.modulate = Color(1, 1, 1)
		target.speed_component.set_multiplier(1)
		
func configure(factor: float, time: float) -> FreezeEffect:
	slow_factor = factor
	timer = time
	return self
